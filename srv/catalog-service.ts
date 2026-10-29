import cds from '@sap/cds'
import { Products, Product } from '#cds-models/CatalogService'
import { Reviews as DbReviews } from '#cds-models/com/valantic/claude/inventory'

const LOG = cds.log('catalog')

interface RatingRow {
  product_ID: string
  average: number
  count: number
}

export default class CatalogService extends cds.ApplicationService {
  async init() {
    this.before(['SAVE', 'CREATE', 'UPDATE'], Products, this.validatePrice)
    this.after('READ', Products, this.addRatings)
    this.after('READ', Products.drafts, this.addRatings)
    this.on(Product.actions.restock, this.restock)
    return super.init()
  }

  private validatePrice = (req: cds.Request) => {
    const price = (req.data as Product).price
    if (price !== undefined && price !== null && price <= 0) {
      req.error({ status: 400, message: 'PRICE_MUST_BE_POSITIVE', target: 'price' })
    }
  }

  // One aggregate query for the whole result set; no per-row queries
  private addRatings = async (result: Product | Product[] | undefined) => {
    if (!result) return
    const rows = Array.isArray(result) ? result : [result]
    const ids = rows.map((r) => r.ID).filter((id): id is string => !!id)
    if (ids.length === 0) return

    const stats = (await SELECT.from(DbReviews)
      .columns('product_ID', 'avg(rating) as average', 'count(*) as count')
      .where({ product_ID: { in: ids } })
      .groupBy('product_ID')) as RatingRow[]
    const byProduct = new Map(stats.map((s) => [s.product_ID, s]))

    for (const row of rows) {
      if (!row.ID) continue
      const stat = byProduct.get(row.ID)
      row.reviewCount = stat?.count ?? 0
      row.averageRating = stat ? Math.round(stat.average * 10) / 10 : null
    }
  }

  private restock = async (req: cds.Request) => {
    const { quantity } = req.data as { quantity?: number | null }
    if (!quantity || quantity <= 0) {
      return req.reject({ status: 400, message: 'QUANTITY_MUST_BE_POSITIVE', target: 'quantity' })
    }

    const { ID } = req.params[0] as { ID: string }
    const draft = await SELECT.one.from(Products.drafts).columns('ID').where({ ID })
    if (draft) {
      return req.reject({ status: 409, message: 'RESTOCK_NOT_ALLOWED_IN_DRAFT' })
    }

    await UPDATE(Products, ID).with({ stock: { '+=': quantity } })
    LOG.info(`restocked product ${ID} by ${quantity}`)
    return SELECT.one.from(Products, ID)
  }
}
