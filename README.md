# 🏢 SQL Data Warehouse | Medallion Architecture

A modern SQL Data Warehouse project built using SQL Server that demonstrates an end-to-end ETL pipeline following the **Medallion Architecture (Bronze → Silver → Gold)**.

The project imports raw CRM and ERP datasets, transforms them into clean and standardized data, and finally creates an analytical data model optimized for reporting and business intelligence.

> **Learning Project:** This project is based on the excellent SQL Data Warehouse tutorial by **Data With Baraa**. The implementation, documentation, and GitHub organization represent my own learning journey.

---

# 📌 Project Objectives

- Build a scalable SQL Data Warehouse
- Design a layered ETL pipeline
- Integrate multiple data sources
- Clean and transform raw datasets
- Create business-ready analytical tables
- Practice real-world SQL development

---

# 🏗️ Architecture

The project follows the **Medallion Architecture**.

```
CRM + ERP CSV Files
        │
        ▼
 ┌────────────────┐
 │ Bronze Layer   │
 │ Raw Data       │
 └────────────────┘
        │
        ▼
 ┌────────────────┐
 │ Silver Layer   │
 │ Cleaned Data   │
 └────────────────┘
        │
        ▼
 ┌────────────────┐
 │ Gold Layer     │
 │ Analytics      │
 └────────────────┘
```

---

# 🥉 Bronze Layer

The Bronze layer stores the source data exactly as received.

### Responsibilities

- Import CSV files
- Preserve original data
- Minimal validation
- Raw data storage

---

# 🥈 Silver Layer

The Silver layer improves data quality.

### Responsibilities

- Remove duplicates
- Handle NULL values
- Standardize formats
- Apply business rules
- Validate data quality

---

# 🥇 Gold Layer

The Gold layer provides business-ready datasets.

### Responsibilities

- Create dimension tables
- Create fact tables
- Build analytical models
- Support reporting and dashboards

---

# 📂 Repository Structure

```
SQL-Data-Warehouse/
│
├── datasets/
├── docs/
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
├── tests/
└── README.md
```

---

# 🛠️ Tech Stack

- SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- Git
- GitHub

---

# 📊 Data Sources

The project uses sample CRM and ERP datasets provided in the tutorial repository.

Data is loaded from CSV files into SQL Server and transformed through the Bronze, Silver, and Gold layers.

---

# 🚀 Skills Demonstrated

- Data Warehousing
- ETL Development
- SQL Programming
- Data Cleaning
- Data Transformation
- Data Modeling
- Star Schema Design
- Database Design
- Git & GitHub

---

# 📈 Project Progress

- [x] Repository Setup
- [ ] Bronze Layer
- [ ] Silver Layer
- [ ] Gold Layer
- [ ] Documentation
- [ ] Analytics

---

# 📚 Key Learnings

Through this project I am learning:

- Designing modern data warehouses
- Building ETL pipelines in SQL Server
- Working with layered architectures
- Transforming raw data into analytical models
- Organizing professional SQL projects with Git and GitHub

---

# 🙏 Credits

This project is based on the **SQL Data Warehouse** tutorial by **Data With Baraa**.

It is recreated for educational purposes while documenting my own implementation and understanding of the concepts.
