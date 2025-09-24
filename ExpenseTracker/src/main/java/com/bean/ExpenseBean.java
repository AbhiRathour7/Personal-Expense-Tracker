package com.bean;

import java.util.Date;

public class ExpenseBean {
   private int id;
   private String username;
   private double amount;
   private String category;
   private Date expenseDate;
   private String description;

   public ExpenseBean() {}

   public ExpenseBean(String username, double amount, String category, Date expenseDate, String description) {
      this.username = username;
      this.amount = amount;
      this.category = category;
      this.expenseDate = expenseDate;
      this.description = description;
   }

   public int getId() { return id; }
   public void setId(int id) { this.id = id; }
   public String getUsername() { return username; }
   public void setUsername(String username) { this.username = username; }
   public double getAmount() { return amount; }
   public void setAmount(double amount) { this.amount = amount; }
   public String getCategory() { return category; }
   public void setCategory(String category) { this.category = category; }
   public Date getExpenseDate() { return expenseDate; }
   public void setExpenseDate(Date expenseDate) { this.expenseDate = expenseDate; }
   public String getDescription() { return description; }
   public void setDescription(String description) { this.description = description; }
}
