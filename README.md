# Personal Expense Tracker

## Overview
**Personal Expense Tracker** is a Java-based web application built using **JSP, MySQL, HTML, and CSS**. This application allows users to manage their finances efficiently by tracking income, expenses, savings, and generating reports. It also includes a responsive user interface, profile management, and an admin panel for managing users and data.

---

## Features
- **User Registration and Login:** Secure authentication for individual users.
- **Add Income and Expenses:** Track daily income and expenses with category selection.
- **Dashboard & Reports:** View financial summaries, charts, and detailed reports.
- **Profile Management:** Update user profile details.
- **Savings Tracking:** Helps monitor and manage savings goals.
- **Admin Panel:** Admin can manage users and oversee financial data.
- **Responsive UI:** Works seamlessly on desktop and mobile devices.
- **Database Connectivity:** Secure backend using JDBC and MySQL.
- **Validation & Security:** Proper input validation and modular code structure.

---

## Technology Stack
- **Frontend:** HTML, CSS, JSP
- **Backend:** Java (JSP/Servlets)
- **Database:** MySQL
- **Connectivity:** JDBC

---

## Project Structure
ExpenseTracker/
├── src/ # Java source files (Servlets, utilities)
├── WebContent/ # JSP pages and static assets
│ ├── css/ # Stylesheets
│ ├── js/ # JavaScript files (if any)
│ └── images/ # Images
├── lib/ # Libraries (JDBC driver)
└── README.md # Project documentation


---

## Installation & Setup
1. **Clone the repository:**
```bash
git clone https://github.com/AbhiRathour7/Expense--Tracker.git
```
2.Import Project into Eclipse as a Dynamic Web Project.

3.Add MySQL JDBC Driver to the project build path.
4.Create Database:
CREATE DATABASE expense_tracker;

5.Update Database Credentials: Update database username, password, and URL in DBConnection.java.

6.Run on Server: Use Apache Tomcat or any JSP-supported server.

## Usage

Register a new account or login with existing credentials.

Add income and expense entries with date, amount, and category.

View your dashboard for summaries and charts.

Track savings and goals over time.

Admins can manage users and financial data from the admin panel.

## Author

Abhinav Singh

GitHub: https://github.com/AbhiRathour7
