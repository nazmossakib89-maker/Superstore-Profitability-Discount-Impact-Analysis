# Superstore-Profitability-Discount-Impact-Analysis
An end-to-end data analytics project uncovering profitability drivers and discount-related losses in retail transaction data from a US-based superstore, using Excel, SQL, and Power BI.

## 📌 Project Overview

This project moves beyond sales volume to analyze profitability — identifying which product categories, regions, and discount levels are actually profitable versus loss-making. The goal was to practice a full analyst workflow — from raw data cleaning to PivotTable exploration, SQL verification, and a decision-ready Power BI dashboard — while uncovering insights a surface-level sales report would miss.

Dataset: Sample Superstore dataset (widely used for retail analytics practice), containing 9,994 transactions with fields including Sales, Profit, Discount, Category, Sub-Category, Region, State, Segment, and Ship Mode.


## ❓ Business Questions

- Which product categories and sub-categories are the most profitable, and which are consistently losing money?
- Which regions and states generate the highest profit, and which are dragging overall profitability down?
- Is there a relationship between discount percentage and profit — is there a tipping point where discounts start causing losses?
- Which customer segments are most and least profitable?
- Does Ship Mode have any noticeable effect on profit margins?
- What are the top loss-making products, and what do they have in common (category, discount level, region)?


 ## 📊 Excel Analysis

The raw dataset (9,994 transactions) was imported into Excel and converted into a structured Table. Data quality checks confirmed there were no duplicate rows and no missing values across key fields (Sales, Profit, Discount, Category, Region). The Discount field was confirmed to be stored in decimal format (e.g., 0.2 = 20%).

Two calculated columns were added: Profit Margin (Profit ÷ Sales, to measure efficiency rather than raw profit) and Discount Bucket (grouping transactions into No Discount, Low 1–20%, Medium 21–40%, High 41–60%, and Very High 60%+, using nested IF logic).

Three PivotTables and charts were built to answer the core business questions:

1. Profitability by Category and Sub-Category At the category level, all three categories appear profitable — but margins tell a different story: Technology (17.4%) and Office Supplies (17.0%) are efficient, while Furniture lags far behind at just 2.5%, despite generating nearly as much revenue as Technology ($742K vs $836K). Drilling into sub-categories revealed why: Tables (-$17,725) and Bookcases (-$3,473) are outright loss-making, with their losses masked at the category level by strong performers like Chairs (+$26,590) and Furnishings (+$13,059). Supplies, within Office Supplies, is also loss-making (-$1,189).

2. Profitability by Region and State No region shows an overall loss, but efficiency varies widely — West leads with a 14.9% margin, while Central trails at just 7.9%. State-level analysis exposed the cause: 10 states are net loss-makers, led by Texas (-$25,729), followed by Ohio (-$16,971), Pennsylvania (-$15,560), and Illinois (-$12,608). Central region's weak margin is driven almost entirely by losses in Texas and Illinois, while even the top-performing West region has loss-making states (Colorado, Arizona, Oregon) offset by strong results in California and Washington.

3. Discount Impact on Profitability This was the most decisive finding of the analysis. Grouping all 9,994 transactions into discount bands revealed a clear tipping point around the 20% discount mark:

| Discount Level | Orders | Profit Margin |
|---|---|---|
| No Discount | 4,798 | 29.5% |
| Low (1–20%) | 3,803 | 11.9% |
| Medium (21–40%) | 460 | -15.3% |
| High (41–60%) | 215 | -40.7% |
| Very High (60%+) | 718 | -122.6% |

Profitability is positive at 20% discount or below, and turns sharply negative beyond that threshold — reaching a margin of -122.6% at discounts above 60%, meaning the business loses more than a dollar for every dollar of sales in that band. This pattern held across a substantial sample (1,393 orders, ~14% of all transactions), not just a handful of outliers.

4. Top Loss-Making Products Ranking all products by total profit surfaced a mix that category-level analysis alone would not predict: the single biggest loss-maker is a Technology product — the Cubify CubeX 3D Printer (Double Head, -$8,880) — despite Technology being the highest-margin category overall (17.4%). Of the top 10 loss-making products, 5 are Furniture items (mostly tables and conference furniture, reinforcing the earlier sub-category finding), 3 are high-value Technology products (3D printers, a laser printer, a videoconferencing unit), and 2 are Office Supplies. This shows that category-wide profitability can mask a small number of specific, high-cost, low-margin products driving outsized losses.
