import JourneyRunner from "sap/fe/test/JourneyRunner";
import ListReport from "sap/fe/test/ListReport";
import ObjectPage from "sap/fe/test/ObjectPage";
import CustomProductsListGenerated from "./ProductsList.gen";
import CustomProductsObjectPageGenerated from "./ProductsObjectPage.gen";
import CustomReviewsObjectPageGenerated from "./ReviewsObjectPage.gen";

const runner = new JourneyRunner({
    launchUrl: sap.ui.require.toUrl("com/valantic/claude/catalog") + "/test/flp.html#app-preview",
    pages: {
        onTheProductsListGenerated: new ListReport(
            {
                appId: "com.valantic.claude.catalog",
                componentId: "ProductsList",
                entitySet: "",
                contextPath: "/Products"
            },
            CustomProductsListGenerated
        ),
        onTheProductsObjectPageGenerated: new ObjectPage(
            {
                appId: "com.valantic.claude.catalog",
                componentId: "ProductsObjectPage",
                entitySet: "",
                contextPath: "/Products"
            },
            CustomProductsObjectPageGenerated
        ),
        onTheReviewsObjectPageGenerated: new ObjectPage(
            {
                appId: "com.valantic.claude.catalog",
                componentId: "ReviewsObjectPage",
                entitySet: "",
                contextPath: "/Products/reviews"
            },
            CustomReviewsObjectPageGenerated
        )
    },
    async: true
});

export default runner;
