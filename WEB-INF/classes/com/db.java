package com;

import java.sql.*;
import java.io.*;
import java.util.*;
import java.math.*;
import basketItem.basketItem;

public class db
{
	/**
	* CONNECTS TO DATABASE
	* 
	* @param  None
	* @return Connection to the database
	*/
	public Connection getConnection()throws IOException
	{
		Connection conn = null;
		
		try
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/visiondb14","username", "password");
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
	
	//====================================================================================
	//INITIALISATION - WELCOME TO VISION
	//====================================================================================
	
	/**
	* GETS THE NEXT TRANSACTION ID
	* 
	* @param  None
	* @return Integer value of the next transaction ID
	*/
	public int getNextTransID() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT TransactionID FROM transactiondetails ORDER BY TransactionID DESC";
		ResultSet rs = stmt.executeQuery(statement);
		
		int toReturn = 1;
		
		try
		{
			rs.next();
			toReturn = rs.getInt ("TransactionID");		
			toReturn++;
		}catch(Exception e)
		{
			
		}
		return toReturn;
	}
	
	//===========================================================================================
	//SEARCH
	//===========================================================================================
		
	
	/**
	* GETS SUPPLIERS CURRENTLY IN STOCK RECORDS	
	* 
	* @param  None
	* @return A ResultSet of suppliers in the database
	*/
	public ResultSet getSuppliers() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT distinct(Supplier) FROM productdetails ORDER BY Supplier ASC";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;
	}

	/**
	* GETS CATEGORIES CURRENTLY IN STOCK RECORDS
	* 
	* @param  None
	* @return A ResultSet of categories in the database
	*/
	public ResultSet getCategories() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT distinct(Category) FROM productdetails ORDER BY Category ASC";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;
	}
	
	/**
	* GETS THE PRODUCT DETAILS FOR PRODUCTS SUPPLIED BY A PARTICULAR SUPPLIER
	* 
	* @param  Supplier  - Supplier which should be used to find products
	* @return A ResultSet of products by a particular supplier
	*/
	public ResultSet findBySupplier(String Supplier) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 	"SELECT * FROM productdetails WHERE Supplier = '" + Supplier + "'";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;		
	}
	
	/**
	* GETS THE PRODUCT DETAILS FOR PRODUCTS WHICH BELONG TO A PARTICULAR CATEGORY
	* 
	* @param  Category  - Category which should be used to find products
	* @return A ResultSet of products belonging to a particular category
	*/
	public ResultSet findByCategory(String Category) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT * FROM productdetails WHERE Category = '" + Category + "'";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;		
	}
	
	/**
	* GETS THE PRODUCT DETAILS FOR PRODUCTS WHICH ARE SUPPLIED BY A PARTICULAR SUPPLIER AND WHICH BELONG TO A PARTICULAR CATEGORY
	* 
	* @param  Supplier   - Supplier which should be used to find products
	* @param  Category   - Category which should be used to find products
	* @return A ResetSet of products supplied by a particular supplier and part of a particular category
	*/
	public ResultSet findBySupplierCategory(String Supplier, String Category) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT * FROM productdetails WHERE Supplier = '" + Supplier + "' AND Category = '" + Category + "'";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;		
	}
	
	//===========================================================================================
	//STOCK RECORDS
	//===========================================================================================
	
	/**
	* GETS ALL STOCK RECORDS
	* 
	* @param  None 
	* @return A ResultSet containing all the products in the stock records
	*/
	public ResultSet getStockRecords () throws SQLException, IOException
	{
		db  dbconn = new db();		
		Statement stmt = dbconn.getConnection().createStatement();
		
		String statement = "SELECT * FROM productdetails";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;
	}
	
	/**
	* GETS ALL PRODUCT DETAILS FOR AN ITEM
	* 
	* @param  ID - Product ID for which the details should be found
	* @return A ResultSet containing the product details of the requested product
	*/
	public ResultSet findByID (int ID) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT * FROM productdetails WHERE ProductID = '" + ID + "'";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;
	}
	
	/**
	* ADDS A NEW PRODUCT TO THE STOCK RECORDS
	* 
	* @param ImageI        - Location of image to add to database
	* @param ProductNameI  - Product Name to add to database
	* @param BrandI		   - Brand to add to database
	* @param RangeI		   - Range to add to database
	* @param SupplierI     - Supplier to add to database
	* @param RestockDateI  - Restock Date to add to database
	* @param SalePriceI    - Sale Price to add to database
	* @param PurchaseCostI - Purchase Cost to add to database
	* @param CategoryI     - Category to add to database
	* @param ProductQuantity-ProductQuantity to add to database
	* @param Information   - Information to add to database
	* @return None
	*/
	public void addNewProduct(String ImageI, String ProductNameI, String BrandI, String RangeI, String SupplierI, String RestockDateI, String SalePriceI, String PurchaseCostI, String CategoryI, String ProductQuantityI, String InformationI)  throws SQLException, IOException
	{	
		String Image = ImageI;
		String ProductName = removeApp(ProductNameI);						 		
		String Brand = removeApp(BrandI);
		String Range = removeApp(RangeI);					
		String Supplier	= removeApp(SupplierI);					
		java.sql.Date RestockDate = java.sql.Date.valueOf(RestockDateI);				
		float SalePrice = Float.parseFloat (SalePriceI);
		float PurchaseCost = Float.parseFloat (PurchaseCostI);					
		String Category	= removeApp(CategoryI);			
		int ProductQuantity = Integer.parseInt (ProductQuantityI);				
		String Information = removeApp(InformationI);
		
		
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 
			("INSERT INTO `visiondb14`.`productdetails` " +
			"(`ProductID`, `ProductName`, `Brand`, `Range`, `Supplier`, `RestockDate`, `SalePrice`, `PurchaseCost`, `Category`, `ProductQuantity`, `Information`, `Image`) " +  
			"VALUES (NULL, '" + ProductName +"', '" + Brand +"', '" + Range +"', '" + Supplier +"', '" + RestockDate +"', '" + SalePrice +"', '" + PurchaseCost +"', '" + Category +"', '" + ProductQuantity +"', '" + Information +"', '" + Image +"')");
		
		stmt.executeUpdate(statement);
	}
	
	/**
	* UPDATE A PRODUCTS DETAILS (INC IMAGE)
	* 
	* @param ImageI        - Location of image to update database with
	* @param ProductIDI    - ProductID of product to update
	* @param ProductNameI  - Product Name to update database with
	* @param BrandI		   - Brand to update database with
	* @param RangeI		   - Range to update database with
	* @param SupplierI     - Supplier to update database with
	* @param RestockDateI  - Restock Date to update database with
	* @param SalePriceI    - Sale Price to update database with
	* @param PurchaseCostI - Purchase Cost to update database with
	* @param CategoryI     - Category to update database with
	* @param ProductQuantity-ProductQuantity to update database with
	* @param Information   - Information to update database with
	* @return None
	*/
	public void updateProductDetails(String ImageI, String ProductIDI, String ProductNameI, String BrandI, String RangeI, String SupplierI, String RestockDateI, String SalePriceI, String PurchaseCostI, String CategoryI, String ProductQuantityI, String InformationI)  throws SQLException, IOException
	{		
		String Image = ("images/database/" + ImageI);
		int ProductID = Integer.parseInt (ProductIDI);							 		
		String ProductName = removeApp(ProductNameI);						 		
		String Brand = removeApp(BrandI);
		String Range = removeApp(RangeI);					
		String Supplier	= removeApp(SupplierI);					
		java.sql.Date RestockDate = java.sql.Date.valueOf(RestockDateI);				
		float SalePrice = Float.parseFloat (SalePriceI);
		float PurchaseCost = Float.parseFloat (PurchaseCostI);					
		String Category	= removeApp(CategoryI);			
		int ProductQuantity = Integer.parseInt (ProductQuantityI);				
		String Information = removeApp(InformationI);	
		
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 
			("UPDATE `visiondb14`.`productdetails` " + 
			"SET `ProductName` = '" + ProductName + "', " + 
			"`Image` = '" + Image + "', " + 	
			"`Brand` = '" + Brand + "', " + 
			"`Range` = '" + Range + "', " +
			"`Supplier` = '" + Supplier + "', " +
			"`RestockDate` = '" + RestockDate + "', " +
			"`SalePrice` = '" + SalePrice + "', " +
			"`PurchaseCost` = '" + PurchaseCost + "', " +
			"`Category` = '" + Category + "', " +
			"`ProductQuantity` = '" + ProductQuantity + "', " +
			"`Information` = '" + Information + "' " +
			"WHERE `productdetails`.`ProductID` =" + ProductID + "");
		
		stmt.executeUpdate(statement);
	}

	/**
	* UPDATE A PRODUCTS DETAILS (EXC IMAGE)
	* 
	* @param ProductIDI    - ProductID of product to update
	* @param ProductNameI  - Product Name to update database with
	* @param BrandI		   - Brand to update database with
	* @param RangeI		   - Range to update database with
	* @param SupplierI     - Supplier to update database with
	* @param RestockDateI  - Restock Date to update database with
	* @param SalePriceI    - Sale Price to update database with
	* @param PurchaseCostI - Purchase Cost to update database with
	* @param CategoryI     - Category to update database with
	* @param ProductQuantity-ProductQuantity to update database with
	* @param Information   - Information to update database with
	* @return None
	*/
	public void updateProductDetailsExImage(String ProductIDI, String ProductNameI, String BrandI, String RangeI, String SupplierI, String RestockDateI, String SalePriceI, String PurchaseCostI, String CategoryI, String ProductQuantityI, String InformationI)  throws SQLException, IOException
	{					
		int ProductID = Integer.parseInt (ProductIDI);							 		
		String ProductName = removeApp(ProductNameI);						 		
		String Brand = removeApp(BrandI);
		String Range = removeApp(RangeI);					
		String Supplier	= removeApp(SupplierI);					
		java.sql.Date RestockDate = java.sql.Date.valueOf(RestockDateI);				
		float SalePrice = Float.parseFloat (SalePriceI);
		float PurchaseCost = Float.parseFloat (PurchaseCostI);					
		String Category	= removeApp(CategoryI);			
		int ProductQuantity = Integer.parseInt (ProductQuantityI);				
		String Information = removeApp(InformationI);	
		
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = 
			("UPDATE `visiondb14`.`productdetails` " + 
			"SET `ProductName` = '" + ProductName + "', " + 
			"`Brand` = '" + Brand + "', " + 
			"`Range` = '" + Range + "', " +
			"`Supplier` = '" + Supplier + "', " +
			"`RestockDate` = '" + RestockDate + "', " +
			"`SalePrice` = '" + SalePrice + "', " +
			"`PurchaseCost` = '" + PurchaseCost + "', " +
			"`Category` = '" + Category + "', " +
			"`ProductQuantity` = '" + ProductQuantity + "', " +
			"`Information` = '" + Information + "' " +
			"WHERE `productdetails`.`ProductID` =" + ProductID + "");
	
		stmt.executeUpdate(statement);
	}

	/**
	* DELETE PRODUCT
	* 
	* @param  ProductID - ProductID of product to be deleted 
	* @return None
	*/
	public void deleteProduct(int ProductID) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "DELETE FROM productdetails WHERE ProductID = " + ProductID + "";
	
		stmt.executeUpdate(statement);
	}
	
	/**
	* CALCULATES CURRENT STOCK VALUE
	* 
	* @param  None 
	* @return A BigDecimal containing the current stock value
	*/
	public BigDecimal currentStockValue() throws SQLException, IOException
	{
		db  dbconn = new db();		
		Statement stmt = dbconn.getConnection().createStatement();
		
		String statement = ("SELECT SalePrice , ProductQuantity FROM productdetails");
		ResultSet rs = stmt.executeQuery(statement);
		
		BigDecimal CSV = new BigDecimal(0.0);
		
		while(rs.next())
		{
			BigDecimal SalePrice = new BigDecimal (rs.getString("SalePrice"));
			BigDecimal ProductQuantity = new BigDecimal (rs.getString("ProductQuantity"));
			BigDecimal OverallWorth = SalePrice.multiply(ProductQuantity);
			
			CSV = CSV.add(OverallWorth);
		}
		
		return CSV;
	}

	/**
	* REPLACES A ' FOR A ` TO PREVENT ERRORS IN SQL
	* 
	* @param  cleanUp - The string which needs to be cleaned up 
	* @return A cleaned up string
	*/
	public String removeApp (String cleanUp)
	{
		String cleaned = cleanUp.replace('\'', '`');
		return cleaned;
	}	

	/**
	* GETS QUANTITY FOR A PRODUCT STORED WITHIN THE DATABASE (INITIAL QUANTITY)
	* 
	* @param  ProductID - The ProductID of the product which initial quantity should be retrieved
	* @return Integer containing the quantity initially available for a product
	*/
	public int getInitialQuantity (int ProductID) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT ProductQuantity FROM productdetails WHERE ProductID = '" + ProductID + "'";
		ResultSet rs = stmt.executeQuery(statement);
		int InitialQuantity = -1;
		
		while (rs.next())
		{
			String InitialQuantityString = rs.getString("ProductQuantity");
			InitialQuantity = Integer.parseInt(InitialQuantityString);
		}
		
		return InitialQuantity;
	}

	//====================================================================================
	//TRANSACTION RECORDS
	//====================================================================================

	/**
	* GETS ALL TRANSACTION RECORDS
	* 
	* @param  none 
	* @return A ResultSet containing all transactions in the transaction records
	*/
	public ResultSet getTransactions() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT * FROM transactiondetails ORDER BY TransactionID DESC";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;
	}

	/**
	* GETS ALL BASKET ITEMS WHICH ARE A PART OF A TRANSACTION
	* 
	* @param TransactionID - The TransactionID for which basket items need to be retrieved
	* @return A ResultSet containing all the basket items in the transaction
	*/
	public ResultSet getBasketItems(int TransactionID) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT * FROM basketitem WHERE TransactionID = '"+TransactionID+"'";
		ResultSet rs = stmt.executeQuery(statement);
		
		return rs;
	}
	
	/**
	* UPDATES DATABASE WHEN A TRANSACTION IS COMPLETE
	* 
	* @param  shoppingBasket - Contains the items sold
	* @param  transactionID - The transactionID which should be used for the transaction
	* @param  Total - Total of the transaction
	* @param  AmountGiven - Amount given for the transaction
	* @param  ChangeDue - ChangeDue for a transaction
	* @return None
	*/
	public void executeUpdate(Vector shoppingBasket, int transactionID, BigDecimal Total, BigDecimal AmountGiven, BigDecimal ChangeDue) throws SQLException, IOException
	{
		for (int i = 0; i < shoppingBasket.size(); i++)
		{
			basketItem bI = (basketItem)(shoppingBasket.get(i));
			int ProductID = bI.getProductID();
			int QuantityToPurchase = bI.getQuantityToPurchase();
			
			updateDB(ProductID, QuantityToPurchase);
		}
		storeTransaction(shoppingBasket, transactionID, Total, AmountGiven, ChangeDue);	
	}
	
	/**
	* UPDATES QUANTITIES IN DATABASE OF ITEMS IN THE TRANSACTION
	* 
	* @param  ProductID - ProductID of product whose quantity needs updating
	* @param  ReduceBy - The amount a products quantiy needs reducing by
	* @return None
	*/
	public void updateDB(int ProductID, int ReduceBy) throws SQLException, IOException
	{
		ResultSet rs = findByID(ProductID);
		int CurrentQuantityLevel = 0;
		int NewQuantityLevel;
		
		while (rs.next())
		{
			CurrentQuantityLevel = rs.getInt("ProductQuantity");
		}
		
		NewQuantityLevel = CurrentQuantityLevel - ReduceBy;
		
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "UPDATE productdetails SET ProductQuantity = '"+ NewQuantityLevel +"' WHERE ProductID ="+ ProductID +"";
		
		stmt.executeUpdate(statement);
	}
	
	/**
	* STORES THE DETAILS OF A TRANSACTION
	* 
	* @param  shoppingBasket - Contains the items sold
	* @param  transactionID - The transactionID which should be used for the transaction
	* @param  Total - Total of the transaction
	* @param  AmountGiven - Amount given for the transaction
	* @param  ChangeDue - ChangeDue for a transaction
	* @return None
	*/
	public void storeTransaction (Vector shoppingBasket, int transactionID, BigDecimal Total, BigDecimal AmountGiven, BigDecimal ChangeDue) throws SQLException, IOException
	{
		db  dbconn = new db();
		Statement stmt = dbconn.getConnection().createStatement();
		
		float fTotal = Total.floatValue();
		float fAmountGiven = AmountGiven.floatValue();
		float fChangeDue = ChangeDue.floatValue();
		
		String statement = 
				("INSERT INTO `visiondb14`.`transactiondetails` (`TransactionID` ,`SaleTime` ,`Total` ,`AmountGiven` ,`ChangeDue`) VALUES ('"+transactionID+"', CURRENT_TIMESTAMP, '"+fTotal+"', '"+fAmountGiven+"', '"+fChangeDue+"')");
			
			stmt.executeUpdate(statement);
		
		
		for (int i = 0; i < shoppingBasket.size(); i++)
		{
			basketItem bI = (basketItem)(shoppingBasket.get(i));

			int ProductID = bI.getProductID();
			int QuantitySold = bI.getQuantityToPurchase();
			
			
			statement = 
		("INSERT INTO `visiondb14`.`basketitem` (`TransactionID` ,`ProductID` ,`QuantitySold`) VALUES ('"+transactionID+"', '"+ProductID+"', '"+QuantitySold+"')");
			
			stmt.executeUpdate(statement);
		}
	}
	
	/**
	* DELETES A TRANSACTION
	* 
	* @param  TransactionID - The TransactionID of the transaction to be deleted
	* @return None
	*/
	public void deleteTransaction(int TransactionID) throws SQLException, IOException
	{
		Statement stmt = getConnection().createStatement();
		
		String statement = ("DELETE FROM transactiondetails WHERE TransactionID = "+TransactionID+"");	stmt.executeUpdate(statement);
		String statement2 = ("DELETE FROM basketitem WHERE TransactionID = "+TransactionID+"");	stmt.executeUpdate(statement2);	
	}

	/**
	* CLEARS ALL DATA STORED IN THE TRANSACTION DETAILS AND BASKETITEM TABLES 
	*
	* @return None
	*/
	public void clearTransactions()throws SQLException, IOException
	{
		Statement stmt = getConnection().createStatement();
		
		String statement = ("DELETE FROM transactiondetails");	stmt.executeUpdate(statement);
		String statement2 = ("DELETE FROM basketitem");	stmt.executeUpdate(statement2);	
	}

	/**
	* CALCULATES THE TOTAL OF ALL PRODUCTS SOLD IN THE TRANSACTION RECORDS
	* 
	* @return A BigDecimal containing the total of all the products sold in the transaction records
	*/
	public BigDecimal getRunningTotal() throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = "SELECT Total FROM transactiondetails";
		ResultSet rs = stmt.executeQuery(statement);
		
		BigDecimal RunningTotal = new BigDecimal(0);
		
		while(rs.next())
		{
			RunningTotal = RunningTotal.add(new BigDecimal(rs.getString("Total")));
		}
		return RunningTotal;
	}
	
	/**
	* CALCULATES THE TOP 3 BEST SELLING PRODUCTS
	* 
	* @return A string containing the ProductIDs and Quantities Sold of the top 3 sellers
	*/
	public String bestSeller()throws SQLException, IOException
	{		
		Statement stmt = getConnection().createStatement();
		
		String statement = ("SELECT distinct(ProductID) FROM basketItem ORDER BY ProductID ASC");
		ResultSet rs = stmt.executeQuery(statement);
		
		int arrayLength = 0;
		
		System.out.println ("About to calculate array length");
		while (rs.next())
		{
			arrayLength++;
		}
		System.out.println ("Length is " + arrayLength);	
	
		rs.beforeFirst();
		int [][] ProductAndQuantity = new int [arrayLength][arrayLength];
		
		int counter = 0;
		
		System.out.println ("About to populate array with product ids");
		while (rs.next())
		{
			ProductAndQuantity [counter][0]= rs.getInt("ProductID");
			System.out.println ("Setting arrray positions [" + counter + "][0] to " + rs.getInt("ProductID"));
			ProductAndQuantity [counter][1]= 0;
			counter++;
		}
		
		System.out.println("Now out of while");
		
		for (int i = 0; i < arrayLength; i++)
		{
			int ProductID = ProductAndQuantity [i][0];
			
			String statement2 = ("SELECT `QuantitySold` FROM `basketItem` WHERE ProductID = "+ProductID+"");
			ResultSet rs2 = stmt.executeQuery(statement2);
			
			int totalQuantitySold = 0;
			
			while (rs2.next())
			{
				totalQuantitySold = totalQuantitySold + rs2.getInt("QuantitySold");
			}
			
			ProductAndQuantity [i][1] = totalQuantitySold;
		}

		System.out.println ("Contents of array");
		for (int i = 0; i < arrayLength; i++)
		{
			System.out.println(ProductAndQuantity [i][0] + " - " + ProductAndQuantity [i][1]);
		}
		
		int no1Product = 0;
		int no1Quant = 0;
		int no2Product = 0;
		int no2Quant = 0;
		int no3Product = 0;
		int no3Quant = 0;
			
		for (int i = 0; i < arrayLength; i++)
		{
			int Prod = ProductAndQuantity [i][0];
			int Quant = ProductAndQuantity [i][1];
			
			//IF QUANTITY IS GREATER THAN NO3 BUT LESS THAN 2 - SET IT AS 3
			if (Quant > no3Quant && Quant < no2Quant)
			{
				no3Product = Prod;
				no3Quant = Quant;
			}
			
			if(Quant == no2Quant)
			{
				no3Product = Prod;
				no3Quant = Quant;
			}
			
			if (Quant > no2Quant && Quant < no1Quant)
			{
				no3Product = no2Product;
				no3Quant = no2Quant;
				
				no2Product = Prod;
				no2Quant = Quant;
			}
			
			if(Quant == no1Quant && Prod != no3Product)
			{
				no2Product = Prod;
				no2Quant = Quant;
			}
			
			if (Quant > no1Quant)
			{
				no3Product = no2Product;
				no3Quant = no2Quant;
				
				no2Product = no1Product;
				no2Quant = no1Quant;
				
				no1Product = Prod;
				no1Quant = Quant;
			}
			
			System.out.println("At the end of loop: " + i);
			System.out.println("Number 3 Product: " + no3Product + " No 3 Quantity: " + no3Quant);
			System.out.println("Number 2 Product: " + no2Product + " No 3 Quantity: " + no2Quant);
			System.out.println("Number 1 Product: " + no1Product + " No 3 Quantity: " + no1Quant);
		}
		
		String toReturn = no1Product+"/"+no1Quant+"/"+no2Product+"/"+no2Quant+"/"+no3Product+"/"+no3Quant;
		
		return toReturn;
	}
	
	//=================================================================
	//RECEIPT
	//=================================================================
	
	/**
	* GETS THE TRANSACTION DETAILS OF A PARTICULAR TRANSACTION
	* 
	* @param  TransactionID - TransactionID of the Transaction for which the details need to be retrieved
	* @return ResultSet containing the transaction details for the transaction
	*/
	public ResultSet makeReceiptDataTransactionDetails(int TransactionID) throws SQLException, IOException
	{
		db  dbconn = new db();
		
		Statement stmt = dbconn.getConnection().createStatement();
		String statement = ("SELECT * FROM `transactiondetails` WHERE `transactiondetails`.`TransactionID` ="+ TransactionID +"");
		ResultSet rs = stmt.executeQuery(statement);

		return rs;
	}
}
