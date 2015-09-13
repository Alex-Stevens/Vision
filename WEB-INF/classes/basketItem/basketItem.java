package basketItem;

import com.db;
import java.sql.*;
import java.io.*;
import java.util.*;
import java.math.*;


public class basketItem
{
	int ProductID;
	int QuantityToPurchase;
	int QuantityInitiallyAvailable;
	

	public basketItem (String ProductIDInit, String QuantityToPurchaseInit)  throws SQLException, IOException
	{	
		db x = new db();
		ProductID = Integer.parseInt(ProductIDInit);
		QuantityToPurchase = Integer.parseInt(QuantityToPurchaseInit);
		QuantityInitiallyAvailable = x.getInitialQuantity(ProductID);
	}
	
	public basketItem (int ProductIDInit, int QuantityToPurchaseInit)  throws SQLException, IOException
	{	
		db x = new db();
		ProductID = ProductIDInit;
		QuantityToPurchase = QuantityToPurchaseInit;
		QuantityInitiallyAvailable = x.getInitialQuantity(ProductID);
		//System.out.println("Subtotal: "+getSubtotal());
	}
	
	public int getProductID()
	{
		return ProductID;
	}
	
	public int getQuantityToPurchase()
	{
		return QuantityToPurchase;
	}
	
	public int getQuantityInitiallyAvailable()
	{
		return QuantityInitiallyAvailable;
	}
	
	public int getQuantityNowAvailable()
	{
		return QuantityInitiallyAvailable - QuantityToPurchase;
	}
	
	public BigDecimal getSubtotal()
	{
		BigDecimal Subtotal = new BigDecimal(0);
		db x = new db();
		
		if (ProductID != 0)
		{	
			try
			{
				ResultSet rs = x.findByID(ProductID);
				
				while (rs.next())
				{				
					BigDecimal SalePrice = new BigDecimal (rs.getString("SalePrice"));
					BigDecimal Quant = new BigDecimal (QuantityToPurchase);
					int dp = 2;

					Subtotal = SalePrice.multiply(Quant);
					Subtotal = Subtotal.setScale(dp, BigDecimal.ROUND_UP);
				}
			}catch(Exception e){}
		}
		else
		{
			Subtotal.valueOf(3);
		}
		return Subtotal;
	}
}