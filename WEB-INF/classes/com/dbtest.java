package com;

import java.sql.*;
import java.io.*;
import java.util.Vector;

public class dbtest
{
	//"SELECT ProductName FROM productdetails WHERE Supplier='Marbel' ORDER BY ProductName desc";
	//"SELECT ProductName, Brand, SalePrice FROM productdetails WHERE ProductName = '" + variable + "'";
	
	public dbtest()
	{
		try
		{
			String x = "1";
			ResultSet trolly = findByID(x);
			System.out.println("About to enter while loop");
			while (trolly.next())
			{
				System.out.println("Now in while loop");
				String ProductName = trolly.getString ("ProductName");
				System.out.println (ProductName);
			}
		}
		catch(Exception e)
		{
			System.out.println("error is "+e);
		}
	}
	
	//Method for the database connection
	public Connection getConnection()throws IOException
	{
		Connection conn = null;
				
		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbtestdata","username", "password");
		}
		
		catch(SQLException e)
		{
			System.out.println("SQLException: " + e.getMessage());
			while((e = e.getNextException()) != null)
			{
				System.out.println(e.getMessage());
			}
		}
		catch(ClassNotFoundException e)
		{
			System.out.println("ClassNotFoundException: " + e.getMessage());
		}
		catch(InstantiationException e)
		{
			System.out.println("InstantiationException: " + e.getMessage());
		}
		catch(IllegalAccessException e)
		{
			System.out.println("IllegalAccessException: " + e.getMessage());
		}
		
		return conn;
	}

	public ResultSet getData(String searchCriteria) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 
			("SELECT ProductID, ProductName, Information, SalePrice, Image, ProductQuantity FROM productdetails WHERE ProductName = '" + searchCriteria + "'");
		ResultSet rs = stmt.executeQuery(statement);
	
		return rs;
	}
	
	public ResultSet getSuppliers() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 
			("SELECT distinct(Supplier) FROM `ProductDetails` ORDER BY `ProductDetails`.`Supplier`  ASC");
		ResultSet rs = stmt.executeQuery(statement);
	
		return rs;
	}
	
	public ResultSet getCategories() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 												//Must be changed when using testdatadb
			("SELECT distinct(Category) FROM `ProductDetails` ORDER BY `ProductDetails`.`Category`  ASC");
		ResultSet rs = stmt.executeQuery(statement);
	
		return rs;
	}
	
	public ResultSet findByID (int ID) throws SQLException, IOException
	{
		System.out.println("Now in findByID int edition");
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 
			("SELECT * FROM ProductDetails WHERE ProductID = '" + ID + "'");
		ResultSet rs = stmt.executeQuery(statement);
	
		return rs;
	}
	
		public ResultSet findByID (String ID) throws SQLException, IOException
	{
		System.out.println("Now in findByID String edition");
		int x = Integer.parseInt(ID);
		ResultSet rs = findByID(x);
	
		return rs;
	}
	
	public static void main(String[] args)
	{
		dbtest x = new dbtest();

	}
	
}//end class