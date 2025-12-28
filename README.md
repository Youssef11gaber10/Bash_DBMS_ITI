# 🗄️ Bash Shell Script Database Management System (DBMS)

## 📌 Overview
This project is a **Database Management System (DBMS)** implemented using **Bash Shell Scripting**.  
It allows users to **create, manage, and manipulate databases and tables** using a **menu-driven CLI interface**.

The system stores all data on the **local file system**, simulating how real DBMS engines work internally.

---

## 🎯 Project Objectives
- Understand how databases work internally  
- Practice Bash scripting and file handling  
- Apply modular programming concepts  
- Validate user input and enforce constraints  

---

## 🚀 Features

### 🔹 Main Menu
- Create Database  
- List Databases  
- Connect to Database  
- Drop Database  

### 🔹 Database Menu (After Connecting)
- Create Table  
- List Tables  
- Drop Table  
- Insert Into Table  
- Select From Table  
- Delete From Table  
- Update Table  

---

## 🧠 Core Concepts

- Each **Database** is stored as a **directory**
- Each **Table** contains:
  - `.data` → stores records
  - `.meta` → stores column definitions and primary key
- Supports:
  - Data type validation
  - Primary key constraint
  - Formatted output display
- Modular architecture (each feature in a separate script)

---

## 📂 Project Structure

