package tools;

import java.sql.*;
import java.io.*;
import java.util.*;
import java.math.*;

import basketResult.basketResult;
import basketItem.basketItem;
import resultItem.resultItem;
import com.db;

public class tools
{
	db db;
	public tools()
	{
		db = new db();
	}
	
	
	//ADDS ITEM TO BASKET
	public basketResult addToBasket (Vector shoppingBasket, int InputtedProductID, int InputtedQuantity) throws SQLException, IOException 
	{
		basketResult toReturn = new basketResult(shoppingBasket, "");
		
		//CHECK IF THEY ADDED A PRODUCT WITH AN UNACCEPTABLE QUANTITY
		if (InputtedQuantity <= 0)
		{
			toReturn = new basketResult(shoppingBasket, "Unsuitable Quantity");
		}
		else
		{
			//MONITORS WHETHER THE ITEM TO BE ADDED HAS BEEN ADDED OR NOT
			boolean hasAdded = false;
			
			//CHECKS BASKET TO SEE IF PRODUCT IS ALREADY IN BASKET
			for (int z=0; z < shoppingBasket.size(); z++)
			{
				basketItem bI = (basketItem)(shoppingBasket.get(z));
				
				//GET PRODUCTID FROM CURRENT SHOPPING BASKET & CHECK IF SAME TO THE ONE ENTERED
				int vecProductID = bI.getProductID();
				
				//COMPARE PRODUCTIDs
				if (InputtedProductID == vecProductID)
				{
					//REMOVE THE ITEM FROM THE BASKET
					shoppingBasket.remove(z);
					
					//RECALCUALTE QUANTITY
					int vecQuantityToPurchase = bI.getQuantityToPurchase();
					int newQuantity = InputtedQuantity + vecQuantityToPurchase;
					
					//CHECK THAT THE NEW QUANTITY IS NOT MORE THAN WHAT IS IN STOCK & ADDS IT TO BASKET IF ACCEPTABLE					
					if (newQuantity <= bI.getQuantityNowAvailable())
					{
						bI = new basketItem (vecProductID, newQuantity);
						shoppingBasket.add(z, bI);
						hasAdded = true; //THE REQUEST TO ADD AN ITEM TO BASKET HAS BEEN DEALT WITH
						
						toReturn = new basketResult(shoppingBasket, "Added Successfully");
					}
					else
					{
						toReturn = new basketResult(shoppingBasket, "Insufficient Quantity");
					}
					
					break; //STOP LOOPING AS THE PRODUCT HAS ALREADY BEEN FOUND IN BASKET & DEALT WITH
				}
			}//END LOOP THROUGH BASKET
			
			//ITEM WAS NOT ALREADY IN BASKET. CREATE A NEW BASKET ITEM.
			if (!hasAdded) 
			{
				//IF THE QUANTITY INPUTTED IS NOT GREATER THAN WHAT IS CURRENTLY IN STOCK, ADD THE ITEM TO THE BASKET
				if (InputtedQuantity <= db.getInitialQuantity(InputtedProductID))
				{
					basketItem bIAdd = new basketItem(InputtedProductID, InputtedQuantity);
					shoppingBasket.addElement(bIAdd);
					toReturn = new basketResult(shoppingBasket, "Added Successfully");
				}
				else
				{
					toReturn = new basketResult(shoppingBasket, "Insufficient Quantity");
				}
			}
		}
		return toReturn;
	}
	
	
	
	//DELETE ITEM FROM BASKET
	public basketResult deleteItem (Vector shoppingBasket, int ProductID) throws SQLException, IOException
	{
		//LOOP THROUGH BASKET TO FIND ITEM TO DELETE
		for (int z=0; z < shoppingBasket.size(); z++)
		{
			//TAKE OUT PRODUCTID FROM BASKET
			basketItem bI = (basketItem)(shoppingBasket.get(z));
			int vecProductID = bI.getProductID();
			
			//CHECK IF CURRENT ITEM MATCHES ONE TO BE REMOVED
			if (ProductID == vecProductID)
			{
				shoppingBasket.remove(z);//REMOVE THE ITEM
				break;//STOP LOOPING THE PRODUCT WAS FOUND
			}
		}
		basketResult toReturn = new basketResult(shoppingBasket, "Item Deleted");
		return toReturn;
	}
	
	
	
	//UPDATES QUANTITY
	public basketResult updateQuantity (Vector shoppingBasket, int ProductID, int InputtedQuantity) throws SQLException, IOException
	{
		//CHECKS IF QUANTITY WAS LESS OR EQUAL TO 0. IE: DELETE THE ITEM
		if (InputtedQuantity <= 0)
		{
			basketResult shoppingBasketUpdated = deleteItem (shoppingBasket, ProductID);//SEND ITEM TO BE DELETED
			
			return shoppingBasketUpdated;
		}
		
		//CHECKS THAT THE QUANTITY ENTERED IS NOT MORE THAN IS AVAILABLE
		if (InputtedQuantity <= db.getInitialQuantity(ProductID))
		{
			//LOOP THROUGH THE BASKET TO FIND THE PRODUCT TO UPDATED
			for (int z=0; z < shoppingBasket.size(); z++)
			{
				basketItem bI = (basketItem)(shoppingBasket.get(z));
				
				int vecProductID = bI.getProductID();
				
				//CHECKS IF PRODUCT ID TO BE UPDATED IS EQUAL TO CURRENT PRODUCT ID IN LOOP
				if (ProductID == vecProductID)
				{
					shoppingBasket.remove(z);//REMOVE FROM BASKET
					bI = new basketItem(vecProductID, InputtedQuantity);//MAKE A NEW BASKET ITEM WITH THE UPDATED QUANTITY
			
					shoppingBasket.add(z, bI);//ADD IT TO THE BASKET
					break;//STOP LOOPING ITEM WAS FOUND
				}
			}
			basketResult toReturn = new basketResult (shoppingBasket, "Quantity Updated");
			return toReturn;
		}
		//QUANTITY IS GREATER THAN WHAT IS AVAILABLE. RETURN THE ORIGINAL BASKET
		else
		{
			basketResult toReturn = new basketResult(shoppingBasket, "Quantity is greater than that available");
			return toReturn;
		}
	}
	
	//SEARCH ALGORITHM
	public Vector getResultsFor(String searchBox, String inSupplier, String inCategory) throws SQLException, IOException
	{
		//Processed inputs
		Vector inputParts = tokenise(searchBox);		
		String Supplier = inSupplier;
		String Category = inCategory;
		
		Vector results = determineSearchPool(inputParts, Supplier, Category);
		
		//Vector results = pointScore(inputParts, rs);
		
		Comparator r = Collections.reverseOrder();
		Collections.sort(results , r);
		
		for (int i = 0; i < results.size(); i++)
		{
			resultItem item = (resultItem)(results.get(i));
			int score = item.getScore();
			
			if (score == 0)
			{
				results.removeElementAt(i);
				i--;
			}
		}
		
		return results;
	}
	
	public Vector tokenise(String input)
	{
		String [] part = input.split(" ");
		Vector parts = new Vector();
		
		//Making vector & l case
		for (int a = 0; a < part.length; a++)
		{
			String b = part [a];
			parts.add(b.toLowerCase());
		}
		
		//Trimming
		for (int a = 0; a < parts.size(); a++)
		{
			String toTrim = (String)(parts.elementAt(a));
		
			if (toTrim.equals(""))
			{
				//System.out.println("== IN IF == ");
				parts.removeElementAt(a);
			}
		}
		
		return parts;
	}

	public Vector determineSearchPool(Vector inputParts, String Supplier, String Category) throws SQLException, IOException
	{
		db db = new db();
		Vector results = new Vector();
		
		//Determine search pool
		boolean useInputParts = false;
		boolean useSupplier = false;
		boolean useCategory = false;
		
		if (inputParts.size() != 0)
		{
			useInputParts = true;
		}
		if (!(Supplier.equals("any")))
		{
			useSupplier = true;
		}
		if (!(Category.equals("any")))
		{
			useCategory = true;
		}
		
		//===============================
		//COMBINATIONS
		//===============================
		
		if (useInputParts == false && useSupplier == false && useCategory == false)
		{
			System.out.print("Nothing to search for");
		}
	
		if (useInputParts == true && useSupplier == false && useCategory == false)
		{
			
			ResultSet rs = db.getStockRecords();
			results = pointScore(inputParts, rs);
		}
		
		if (useInputParts == true && useSupplier == true && useCategory == false)
		{
			ResultSet rs = db.findBySupplier(Supplier);
			results = pointScore(inputParts, rs);
		}
		
		if (useInputParts == true && useSupplier == false && useCategory == true)
		{
			ResultSet rs = db.findByCategory(Category);
			results = pointScore(inputParts, rs);
		}
		
		if (useInputParts == false && useSupplier == true && useCategory == true)
		{
			ResultSet rs = db.findBySupplierCategory(Supplier, Category);
			
			while (rs.next())
			{
				int ProductID = rs.getInt("ProductID");
				resultItem item = new resultItem(ProductID, 5);
				results.add(item);
			}
		}

		if (useInputParts == false && useSupplier == true && useCategory == false)
		{
			ResultSet rs = db.findBySupplier(Supplier);
			
			while (rs.next())
			{
				int ProductID = rs.getInt("ProductID");
				resultItem item = new resultItem(ProductID, 5);
				results.add(item);
			}
		}
		
		if (useInputParts == false && useSupplier == false && useCategory == true)
		{
			ResultSet rs = db.findByCategory(Category);
			
			while (rs.next())
			{
				int ProductID = rs.getInt("ProductID");
				resultItem item = new resultItem(ProductID, 5);
				results.add(item);
			}
		}
		
		if (useInputParts == true && useSupplier == true && useCategory == true)
		{
			ResultSet rs = db.findBySupplierCategory(Supplier, Category);
			results = pointScore(inputParts, rs);
		}
		return results;
	}
	
	public Vector pointScore(Vector input, ResultSet dataPool) throws SQLException, IOException
	{
		Vector results = new Vector();
		while (dataPool.next())
		{
			System.out.println("About to tokenise dataPool ProductName");
			Vector databaseProductName = tokenise(dataPool.getString("ProductName"));
			System.out.println("Item tokenised. Confirming length: " + databaseProductName.size());
			resultItem resultitem = new resultItem(dataPool.getInt("ProductID"), 0);
			int score = 0;
			
			for (int i = 0; i < input.size(); i++)
			{
				String inputtedWord = (String)(input.get(i));
				System.out.println("Inputted word: " + inputtedWord);
				for (int t = 0; t < databaseProductName.size(); t++)
				{
					String databaseProductNameWord = (String)(databaseProductName.get(t));
					System.out.println("Database word: " + databaseProductNameWord);
					if (inputtedWord.equals(databaseProductNameWord))
					{
						System.out.println("Words match... adding 5 points");
						score = score + 5;
					}
					else
					{
						System.out.println("No match... no points added");
					}
				}
			}
			resultitem.setScore(score);
			results.add(resultitem);
		}		
		
		return results;
	}

}