<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="java.math.*" %>
<%@page import="basketItem.basketItem" %>
<%@page import="basketResult.basketResult" %>

<jsp:useBean id="db" class="com.db" scope="request">
	<jsp:setProperty name="db" property="*"/>
</jsp:useBean>

<jsp:useBean id="tools" class="tools.tools" scope="request">
	<jsp:setProperty name="tools" property="*"/>
</jsp:useBean>

<html>
	<head>
		<title>Vision: Shopping Basket</title>
		<link rel="stylesheet" type="text/css" href="Styles.css" />
	</head>
	
	<body>
	<%	
		//CURRENCY FORMATTER
		NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK);
	%>
		
		<!-- Navigation Bar -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRightActive> 	<img src="images/toolbaricons/shoppingBasket.png" height="40"/></th>
				<th class=tableLeftActive> 		Shopping Basket</th>
				<th class=tableRight> 			<a href="homePage.jsp"><img src="images/toolbaricons/find.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="homePage.jsp">Find a Product</a></th>
				<th class=tableRight> 			<a href="stockRecords.jsp"><img src="images/toolbaricons/stockRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="stockRecords.jsp">Stock Records</a></th>
				<th class=tableRight> 			<a href="transactionRecords.jsp"><img src="images/toolbaricons/transactionRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="transactionRecords.jsp">Transaction Records</a></th>
			</tr>
		</table>
		
		<!-- Status Bar -->						
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Running Total: <% out.print(format.format(db.getRunningTotal())); %></th>
			</tr>
		</table>
				
		</br>
			
	<%
		//ADD TO BASKET VARIABLES			
		String AddItemProductIDString 				= 		request.getParameter	("AddItemProductID");
		String AddItemQuantityString  				=  		request.getParameter	("AddItemQuantity");
		//CLEAR BASKET BUTTON
		String ToClear		 						= 		request.getParameter	("toClear");
		//UPDATE BUTTON				
		String UpdateButtonProductIDString 			= 		request.getParameter 	("UpdateButtonProductID");
		String UpdateButtonQuantityString 			= 		request.getParameter 	("UpdateButtonQuantity");
		//DELETE BUTTON
		String DeleteButtonProductIDString			= 		request.getParameter 	("DeleteButtonProductID");
		 
		//=====================================================================================================
		//DECISIONS
		//=====================================================================================================
		
		//ADD TO BASKET		
		if (AddItemProductIDString != null && AddItemQuantityString != null)
		{
			//CHECK IF A QUANTITY WAS INPUUTED. 
			if (AddItemQuantityString == "")//NO QUANTITY. DISPLAY ERROR MESSAGE
			{
	%>
				<div class=error>You must enter a quantity</div>
	<%
			}
			else//QUANTITY. ATTEMPT TO PROCESS
			{
				try
				{
					//CONVERT INPUTS FROM STRINGS
					int AddItemProductID 	= Integer.parseInt(AddItemProductIDString);
					int AddItemQuantity 	= Integer.parseInt(AddItemQuantityString);
					
					//ADD ITEMS TO BASKET
					basketResult ai = tools.addToBasket(((Vector)(session.getAttribute("shoppingBasket"))), AddItemProductID, AddItemQuantity);
					session.setAttribute ("shoppingBasket", ai.getBasket());
	%>	
					<div class=error><% out.print(ai.getMessage()); %> </div>
	<%			
				}
	
				catch (Exception e)
				{
	%>
					<div class=error>Please input a valid quantity</div>
	<%
				}
			}
		}
			
		//CLEAR BASKET
		if (ToClear != null) //WAS BUTTON PRESSED?
		{
			session.setAttribute("shoppingBasket", new Vector());
		}
				
		//DELETE ITEM
		if (DeleteButtonProductIDString != null)//WAS DELETE BUTTON PRESSED?
		{
			//CONVERT FROM STRING TO INT
			int DeleteButtonProductID = Integer.parseInt (DeleteButtonProductIDString);
			
			//DELETE PRODUCT FROM BASKET
			basketResult bR = tools.deleteItem(((Vector)(session.getAttribute ("shoppingBasket"))), DeleteButtonProductID);
			session.setAttribute ("shoppingBasket", bR.getBasket());
	%>
			<div class=error><%out.print(bR.getMessage());%></div>
	<%
		}
		
		//UPDATES QUANTITY
		if (UpdateButtonProductIDString != null && UpdateButtonQuantityString != null)
		{
			try
			{
				//CONVERT STRINGS TO INT
				int UpdateButtonProductID		= Integer.parseInt (UpdateButtonProductIDString);
				int UpdateButtonQuantity 		= Integer.parseInt (UpdateButtonQuantityString);
				//UPDATE QUANTITY
				basketResult bR 				= tools.updateQuantity(((Vector)(session.getAttribute ("shoppingBasket"))), UpdateButtonProductID, UpdateButtonQuantity);
				session.setAttribute ("shoppingBasket", bR.getBasket());
	%>
				<div class=error><%out.print(bR.getMessage());%></div>
	<%
			}
			catch (Exception e)
			{
	%>
				<div class=error>Please input a valid quantity</div>
	<%
			}
		}
		//=====================================================================================================
	%>
			
	<%
		//=====================================================================================================
		//DISPLAY BASKET CONTENTS
		//=====================================================================================================
		Vector sbMain = (Vector)(session.getAttribute("shoppingBasket"));		//GET BASKET
		if (sbMain.size() == 0) 												//IF EMPTY
		{
			//DISPLAY MESSAGE INFORMING USER BASKET IS EMPTY AND LINK ON HOW TO ADD A PRODUCT
	%>
			Shopping Basket is empty. <a href="homePage.jsp">Click here<a/> to find a product.
				
	<%
		}
		else //BASKET HAS CONTENTS
		{
	%>
				
		<!-- Table header -->
		<table width="100%" border="1">
			<tr>
				<th width="20%">Image</th>
				<th width="60%">Product Details</th>
				<th width="20%">Controls</th>
			</tr>
			
	<%
		//INITIALISE TOTAL VARIABLE
		BigDecimal total = new BigDecimal (0.0);
		
		//LOOP THROUGH BASKET CONTENTS
		for (int i = 0; i < sbMain.size(); i++)
		{
			//TAKE OUT BASKET ITEM FROM BASKET
			basketItem item = (basketItem)(sbMain.get(i));
			
			//ADD TO THE TOTAL, THE COST OF BUYING THE ITEM IN THE DESIRED QUANTITY - RETRIEVED FROM BASKET ITEM
			total = total.add(item.getSubtotal());
							
			//GET & PRINT PRODUCT DETAILS
			ResultSet ProductDetails = db.findByID(item.getProductID());
					
			while (ProductDetails.next())
			{				
				//FORMAT CURRENCY VALUES
				String SalePriceFormatted 			= format.format(ProductDetails.getFloat("SalePrice"));
				String PurchaseCostFormatted 		= format.format(ProductDetails.getFloat("PurchaseCost"));
				String SubtotalFormatted 			= format.format(item.getSubtotal());
	%>
				
			<tr>
				<!-- Image column -->
				<th width="20%" height="100">
					<img src="<%out.print(ProductDetails.getString("Image"));%>" alt="<% out.print(ProductDetails.getString("Image")); %>"  height="150" />
				</th>
				
				<!-- Product Details column -->
				<th>
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(ProductDetails.getString("ProductName")); %></th>
							<th width="34%"><% out.print("Product ID: " + item.getProductID()); %></th>
						</tr>
			
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(ProductDetails.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(ProductDetails.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(ProductDetails.getString("Category")); %></th>
						</tr>
						
						<tr>
							<th width="33%">Supplier: <% out.print(ProductDetails.getString	("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(ProductDetails.getDate("RestockDate")); %></th>
						</tr>
					
					</table>
					
					</br>
					<% out.print(ProductDetails.getString("Information")); %>
				
				</th>
			
				<!-- Controls Column -->
				<th>
					<div class=ProductName>Subtotal <%  out.print(SubtotalFormatted); %></div>
					Purchase Cost <% out.print(PurchaseCostFormatted); %>
	
					</br></br>
						
					<!-- Update Button -->
					<form name="UpdateButton" method="post" action="shoppingBasket.jsp">
						Quantity:
						<input name="UpdateButtonQuantity" type="text" value="<% out.print(item.getQuantityToPurchase());%>" size="1" maxlength="2"> @ <% out.print(SalePriceFormatted); %> each
						<input name="UpdateButtonProductID" type="hidden" value="<%out.print(item.getProductID());%>">
						</br>
						<% out.print(item.getQuantityNowAvailable()); %> available
					</br></br>
				
					<table width="100%" border="0"> <!-- Formatting/layout table for buttons -->
						<tr>
							<th class=alignRight width="25%"><img src="images/toolbaricons/updateQuantity.png" height="20"/></th>
							<th class=alignLeft width="25%"><input type="submit" name="update" value="Update Quantity"></form></th>
							<th class=alignRight width="25%"><img src="images/toolbaricons/delete.png" height="20"/></th>
								<!-- Delete Button -->
								<form name="DeleteButton" method="post" action="shoppingBasket.jsp">
									<input name="DeleteButtonProductID" type="hidden" value="<%out.print(item.getProductID());%>">
									<th class=alignLeft width="25%"><input type="submit" name="delete" value="Delete Item"></th>
								</form>
							</th>
						</tr>
					</table>
			</th>
	<%
			}//End while
		}//end for
		
		String TotalFormatted = format.format(total); //FORMAT TOTAL FOR CURRENCY
		session.setAttribute ("Total", total); //SET TOTAL
	%>
		<!-- Final Row (Total) -->
		<tr>
			<th></th>
			<th></th>
			<th class=Subtotal>Total: <% out.print(TotalFormatted); %></th>
		</tr>
	</table>
	</br>	
	<!-- Shopping Basket Controls -->
	<table width="100%">
		<tr>
			<th class=alignRight width="45%"><img src="images/toolbaricons/clearBasket.png" height="40"/></th>
			<th class=alignLeft width="5%">
				<!-- Empty Basket Button -->
				<form name="EmptyBasket" method="post" action="shoppingBasket.jsp">
					<input name="toClear" type="hidden" value="1">
					<input type="submit" name="clearBasket" value="Clear Basket">
				</form>
			</th>
			
			<th class=alignRight width="5%"><img src="images/toolbaricons/checkout.png" height="40"/></th>
			<th class=alignLeft width="45%">
				<!-- Checkout Button -->
				<form name="Checkout" method="post" action="checkout.jsp">
					<input type="submit" name="Checkout" value="Checkout">
				</form>
			</th>				
		</tr>
	</table>
		
	<%
		}//END OF ELSE (BASKET HAD CONTENTS)
	%>
	</body>
</html>