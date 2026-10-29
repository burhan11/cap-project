Enhance my @db/schema.cds file with following entities

Entity "Reviews":
   - rating: Integer (1 to 5) using @assert.range: [1, 5]
   - comment: String(1024)
   - product: Association to Products

Generate the complete *.cds file with proper syntax, indentation, 
and SAP CAP best practices.