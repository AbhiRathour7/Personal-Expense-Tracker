// Source code is decompiled from a .class file using FernFlower decompiler.
package com.bean;

import java.util.Date;

public class ExpenseBean {
   private int id;
   private String username;
   private double amount;
   private String category;
   private Date expenseDate;
   private String description;

   public ExpenseBean() {
   }

   public ExpenseBean(String username, double amount, String category, Date expenseDate, String description) {
      this.username = username;
      this.amount = amount;
      this.category = category;
      this.expenseDate = expenseDate;
      this.description = description;
   }

   public int getId() {
      return this.id;
   }

   public void setId(int id) {
      this.id = id;
   }

   public String getUsername() {
      return this.username;
   }

   public void setUsername(String username) {
      this.username = username;
   }

   public double getAmount() {
      return this.amount;
   }

   public void setAmount(double amount) {
      this.amount = amount;
   }

   public String getCategory() {
      return this.category;
   }

   public void setCategory(String category) {
      this.category = category;
   }

   public Date getExpenseDate() {
      return this.expenseDate;
   }

   public void setExpenseDate(Date expenseDate) {
      this.expenseDate = expenseDate;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }
}
