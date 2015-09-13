package basketResult;

import com.db;
import java.sql.*;
import java.io.*;
import java.util.*;
import java.math.*;


public class basketResult
{
	Vector SB;
	String Message;

	public basketResult (Vector shoppingBasket, String message)  throws SQLException, IOException
	{	
		SB = shoppingBasket;
		Message = message;
	}

	public Vector getBasket()
	{
		return SB;
	}

	public String getMessage()
	{
		return Message;
	}
	
}