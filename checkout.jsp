<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="java.math.*" %>
<%@page import="basketItem.basketItem" %>

<jsp:useBean id="db" class="com.db" scope="request">
	<jsp:setProperty name="db" property="*"/>
</jsp:useBean>

<html>
	<head>
		<title>Vision: Checkout</title>
		<link rel="stylesheet" type="text/css" href="Styles.css" />
	</head>
	<body>
		
	<%
		NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK); 
	%>
		<!-- Standard Links -->
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
	<%	
		//INITALISE KEY TRANSACTION VARIABLES
		BigDecimal Total				=		(BigDecimal)(session.getAttribute("Total"));
		String TotalFormatted 			=		format.format(Total);
		
		BigDecimal AmountGiven			=		new BigDecimal(0);	
		BigDecimal ChangeDue;
		
		//GET SHOPPING BASKET
		Vector SB = (Vector)(session.getAttribute("shoppingBasket"));
		
		//ACTION & ERROR CODE VARIABLES
		int action = 0;
		int error  = 0;   //ERROR 1 - NOT ENOUGH ENTERED   ERROR 2 - UNSUITABLE VALUE
		
		//====================================================================================
		//DECISIONS - DETERMINE WHAT ACTION TO TAKE
		//====================================================================================
		
		String AmountGivenBuffer   		=		request.getParameter("AmountGiven");
		
		//IF PAGE WAS LOADED PREVIOUSLY
		if(AmountGivenBuffer != null && AmountGivenBuffer != "")
		{
			try //CONVERT INPUT TO A SUITABLE VALUE
			{
				AmountGiven = new BigDecimal (AmountGivenBuffer);
				AmountGiven.setScale(2, BigDecimal.ROUND_HALF_UP);
				
				if (Total.compareTo(AmountGiven) > 0) //WAS THE VALUE LESS THAN THE TOTAL? IF SO RECORD THE ERROR
				{
					error = 1;
				}
				else //IF IT WAS SUITABLE AND THE CONVERSION IS COMPLETE, MOVE ONTO CALCULATING CHANGE DUE
				{
					action = 1;
				}
			}
			catch (Exception e) //COULD NOT CONVERT TO A SUITABLE NUMBER, RECORD THE ERROR
			{
				error = 2;
			}				
		}
		
		//PAGE LOADING FOR FIRST TIME
		if (action == 0)
		{	
	%>

		<!-- Navigation bar -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRightActive> 	<img src="images/toolbaricons/amountGiven.png" height="40"/></th>
				<th class=tableLeftActive> 		Amount Given</th>
				<th class=tableRight> 			<img src="images/toolbaricons/changeDue.png" height="40"/></a></th>
				<th class=tableLeft> 			Change Due</th>
			</tr>
		</table>
	
		<!-- Status bar -->
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Running Total: Running Total: <% out.print(format.format(db.getRunningTotal())); %></th>
			</tr>
		</table>
		
		</br>
	<%	
			//DISPLAY ANY ERRORS THAT MAY HAVE OCCURED FROM PREVIOUS LOADS
			if (error == 1) //DID THE USER NOT ENTER ENOUGH? DISPLAY ERROR
			{
	%>
			<div class=error>The amount entered does not cover the cost of the transaction</div>
	<%
			}
			
			if (error == 2) //DID THE USER INPUT AN UNSUITABLE VALUE? DISPLAY ERROR
			{
	%>
			<div class=error>The value entered was not suitable; input a number in the format XXX.XX</div>
	<%
			}
	%>
		<table class=checkoutTable>
			<tr>
				<th class=tableTextRight>Total </th>
				<th class=tableTextLeft>&nbsp;<% out.print (TotalFormatted); %> </th>
			</tr>
		
			<tr>
				<th class=tableTextRight>
					<form name="AmountGiven" method="post" action="checkout.jsp" >	
						Amount Given</th> 
						<th class=tableTextLeft>&nbsp;&pound;<input type="text" name="AmountGiven" value="" size="10" />
						<input type="submit"  name="post" value="Submit" />
					</form>	
				</th>
			</tr>
		</table>
			
		</br>
				
		<!--BEGIN SHOWING PRODUCTS IN THIS TRANSACTION-->
		
		<!-- Table header -->
		<table width="100%" border="1">
			<tr>
				<th width="20%">Image</th>
				<th width="55%">Product Details</th>
				<th width="10%">Sale Price</th>
				<th width="5%" >Quantity Sold</th>
				<th width="10%">Subtotal</th>
			</tr>
				
	<%
			//LOOP AND PRINT CONTENTS OF BASKET
			for (int i = 0; i < SB.size(); i++)
			{
				//TAKE OUT BASKET ITEM
				basketItem item = (basketItem)(SB.get(i));
						
				//Get the items details and print it out to the table
				ResultSet ProductDetails = db.findByID(item.getProductID());
							
				while (ProductDetails.next())
				{
					String SalePriceFormatted = format.format(ProductDetails.getFloat("SalePrice"));
					String PurchaseCostFormatted = format.format(ProductDetails.getFloat("PurchaseCost"));
	%>
					
			<tr><!--Begin items-->
				
				<!-- Image column -->
				<th width="20%"><img src="<%out.print(ProductDetails.getString("Image"));%>" alt="<% out.print(ProductDetails.getString("Image")); %>"  height="150" /></th>

				<!-- Product Details column -->
				<th width="25%">
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
							<th width="33%">Supplier: <% out.print(ProductDetails.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(ProductDetails.getDate("RestockDate")); %></th>
						</tr>
					</table>
					
	</br><% out.print(ProductDetails.getString("Information")); %>
				
				</th>	
						
				<th width="10%"><% out.print(SalePriceFormatted); %></th>
				<th width="5%"><% out.print(item.getQuantityToPurchase()); %></th>
				<th width="10%"><% out.print(format.format(item.getSubtotal())); %></th>
			</tr>
	
	<%
				}//END WHILE (PRODUCT DETAILS)
			}//END FOR (BASKET CONTENTS)
	%>
		</table>
	<%
	}//END ACTION 0 (WAITING FOR AMOUNT GIVEN)
		
	//CHANGE DUE & OPTIONS	
	if (action == 1)
	{
		String AmountGivenFormatted = format.format(AmountGiven);
		
		//CAUCULATE THE CHANGE DUE
		ChangeDue = (AmountGiven.subtract(Total));
		String ChangeDueFormatted = format.format (ChangeDue);


		//GET TRANSACTIONID
		int transactionID = (Integer)(session.getAttribute("transactionID"));
		
		//UPDATE DATABASE
		db.executeUpdate(SB, transactionID, Total, AmountGiven, ChangeDue);
		
		//UPDATE TRANSACTION ID
		transactionID++;
		session.setAttribute("transactionID", transactionID);
	%>

		<!-- NAVIGATION BAR -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRight> 			<img src="images/toolbaricons/amountGiven.png" height="40"/></th>
				<th class=tableLeft> 			Amount Given</th>
				<th class=tableRightActive> 	<img src="images/toolbaricons/changeDue.png" height="40"/></a></th>
				<th class=tableLeftActive> 		Change Due</th>
			</tr>
		</table>
		
		<!-- STATUS BAR -->
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Running Total: <% out.print(format.format(db.getRunningTotal())); %></th>
			</tr>
		</table>
		
		</br>
				
		<table class=checkoutTable>
			<tr>
				<th class=tableTextRight>Total </th>
				<th class=tableTextLeft>&nbsp;<% out.print (TotalFormatted); %> </th>
			</tr>
			
			<tr>
				<th class=tableTextRight>Amount Given</th>
				<th class=tableTextLeft>&nbsp;<%out.print(AmountGivenFormatted); %> </th>
			</tr>
			
			<tr>
				<th class=tableTextRight>Change Due</th>
				<th class=tableTextLeft>&nbsp;<% out.print(ChangeDueFormatted); %></th>
			</tr>
			
			<tr>
				<th>
			</br>
					<!-- Empty Basket Button -->
					<form name="EmptyBasket" method="post" action="shoppingBasket.jsp">
						<input name="toClear" type="hidden" value="1">
							<table width="100%">
								<tr>
									<th class=alignRight width="95%"><img src="images/toolbaricons/clearBasket.png" height="40"/></th>
									<th class=alignLeft width="5%"><input type="submit" name="clearBasket" value="Clear Basket">
								</tr>
							</table>
					</form>
				
				</th>

				<th>
				</br>
					<!-- Receipt Button -->
					<form name="Receipt" method="post" action="receipt.jsp" target="_blank">
						<table width="100%">
							<tr>
								<th class=alignRight width="5%"><img src="images/toolbaricons/print.png" height="40"/></th>
								<th class=alignLeft width="95%"><input type="submit" name="Receipt" value="Print Receipt"></th>
						<input name="receiptTransactionID" type="hidden" value="<% out.print(transactionID - 1); %>">
							</tr>
						</table>
					</form>
				
				</th>
			</tr>
		</table>
		</br>
	<%		
	}//END ACTION 1 (CHANGE DUE & OPTIONS)
	%>
	</body>
</html>