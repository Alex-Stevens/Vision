<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="java.math.*" %>

<jsp:useBean id="db" class="com.db" scope="request">
	<jsp:setProperty name="db" property="*"/>
</jsp:useBean>

<html>
	<head>
		<title>Vision: Transaction Records</title>
		<link rel="stylesheet" type="text/css" href="Styles.css" />
	</head>
	
	<body>
	<%
		NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK); 
		
		//===============================================================
		//DECISIONS
		//===============================================================
		String deleteTransString = request.getParameter ("deleteTrans");
		String clearTrans = request.getParameter ("clearTrans");
		
		if (deleteTransString != null && deleteTransString != "")
		{
			int deleteTrans = Integer.parseInt(deleteTransString);
			
			try
			{
				db.deleteTransaction(deleteTrans);
			}catch (Exception e)
			{}
		}
		
		if (clearTrans != null && clearTrans != "")
		{
			try
			{
				db.clearTransactions();
				session.setAttribute("transactionID", 1);
				session.setAttribute("runningTotal", new BigDecimal(0));
			}catch(Exception e)
			{
				
			}
		}
		
		//Get transaction ID from session
		int transactionID = (Integer)(session.getAttribute("transactionID"));
	%>
		
		<!-- Standard Links -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRight> 			<a href="shoppingBasket.jsp"><img src="images/toolbaricons/shoppingBasket.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="shoppingBasket.jsp">Shopping Basket</a></th>
				<th class=tableRight> 			<a href="homePage.jsp"><img src="images/toolbaricons/find.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="homePage.jsp">Find a Product</a></th>
				<th class=tableRight> 			<a href="stockRecords.jsp"><img src="images/toolbaricons/stockRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="stockRecords.jsp">Stock Records</a></th>
				<th class=tableRightActive> 	<img src="images/toolbaricons/transactionRecords.png" height="40"/></th>
				<th class=tableLeftActive> 		Transaction Records
			</tr>
		</table>
			
		<table width="100%" border="0">
			<tr>
				<th class=tableRightActive> 	<img src="images/toolbaricons/transactions.png" height="40"/></th>
				<th class=tableLeftActive> 		Transactions</th>
				<th class=tableRight> 			<% if (transactionID > 3) { out.print("<a href=\"topSellers.jsp\"><img src=\"images/toolbaricons/topSellers.png\" height=\"40\"/></a>"); }else{ out.print("<img src=\"images/toolbaricons/topSellers.png\" height=\"40\"/> "); } %></th>
				<th class=tableLeft> 			<% if (transactionID > 3) { out.print("<a href=\"topSellers.jsp\">Top Sellers</a>"); } else { out.print("Top Sellers"); } %></th>
			</tr>
		</table>
						
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Next Transaction: <% out.print(transactionID);%>  Running Total: <% out.print(format.format(db.getRunningTotal())); %></th>
			</tr>
		</table>	
		
		</br>
		
		<!-- ADD PRODUCT BUTTON -->
		<form name="ClearTransactions" method="post" action="transactionRecords.jsp">
			<table width="100%">
				<tr>
					<th class="alignLeft" width="4%"><img src="images/toolbaricons/delete.png" height="40"/></th>
					<th class="alignLeft" width="96%"><input type="submit" name="Edit" value="Clear Transactions">
					<input type="hidden" name="clearTrans" value="1">
				</tr>
			</table>
		</form>	
		
		
		<!-- TABLE HEADERS -->
		<table width="100%" border="1">
			<tr>
				<th width="5%" >Transaction ID</th>
				<th width="10%">Sale Time</th>
				<th width="60%">Product Details</th>
				<th width="10%">Sale Price</th>
				<th width="5%" >Quantity Sold</th>
				<th width="10%">Subtotal</th>
			</tr>
			
			</br>
					
		<%
		ResultSet rs = db.getTransactions();	//GET LIST OF TRANSACTIONS
		
		//GET DATA FROM TRANSACTIONS
		while(rs.next())
		{	
			int TransactionID				= rs.getInt("TransactionID");
			String SaleTimeString			= rs.getTimestamp("SaleTime").toString();
			SaleTimeString					= SaleTimeString.substring(0, 19);
			
			ResultSet BasketItems = db.getBasketItems(TransactionID);
			
			while (BasketItems.next())
			{
				int ProductID				= BasketItems.getInt("ProductID");
				int QuantitySold			= BasketItems.getInt("QuantitySold");

				ResultSet ProductDescription	= db.findByID(ProductID);
			
				while(ProductDescription.next())
				{				
					BigDecimal SalePrice = new BigDecimal (ProductDescription.getString("SalePrice"));
					String SalePriceFormatted = format.format(SalePrice);
	
					BigDecimal Subtotal = (SalePrice.multiply(new BigDecimal (QuantitySold)));
					String SubtotalFormatted = format.format(Subtotal); 
	%>
			<tr <% if (TransactionID % 2 == 0) { out.print("class=even"); } %>>
				<!-- Transaction ID Column -->
				<th><% out.print(TransactionID);	%></th>
				
				<!-- Sale Time Column -->
				<th><% out.print(SaleTimeString);	%></th>
				
				<!-- Product Details column -->
				<th>
					<table width="100%">
						<tr>
							<th><img src="<% out.print(ProductDescription.getString("Image")); %>" alt="" height="150"/><th>
								
							<th>
								<table class=DetailsTable>
									<tr>
										<th class=ProductName width="33%"><% out.print(ProductDescription.getString("ProductName")); %></th>
										<th width="34%"><% out.print("Product ID: " + ProductID); %></th>
										<th></th>
									</tr>
						
									<tr>
										<th class=DetailsTableItem>Brand: <% out.print(ProductDescription.getString("Brand")); %></th>
										<th class=DetailsTableItem>Range: <% out.print(ProductDescription.getString("Range")); %></th>
										<th class=DetailsTableItem>Category: <% out.print(ProductDescription.getString("Category")); %></th>
									</tr>
									
									<tr>
										<th width="33%">Supplier: <% out.print(ProductDescription.getString("Supplier")); %></th>
										<th width="34%">Restock Date: <% out.print(ProductDescription.getDate("RestockDate")); %></th>
										<th></th>
									</tr>
								</table>
							</th>
						</tr>								
					</table>
					</br>
					
					<% out.print(ProductDescription.getString("Information")); %>	
				</th>
				
				<!-- Sale Price column-->
				<th><% out.print(SalePriceFormatted); %></th>
				
				<!-- Quantity Sold column-->
				<th><% out.print(QuantitySold); %></th>
				
				<!-- Subtotal column-->
				<th>
					<% out.print(SubtotalFormatted); %>
						
					<!-- Delete Button -->
					<form name="Delete" method="post" action="transactionRecords.jsp">
						<table width ="100%">
							<tr>
								<th class=tableTextRight width="50%"><img src="images/toolbaricons/delete.png" height="20"/></th>
								<th class=tableTextLeft width="50%"><input type="submit" name="delete" value="Delete Transaction"></th>
							</tr>
						</table>
						<input name="deleteTrans" type="hidden" value="<% out.print(TransactionID); %>">
					</form>
				
					<!-- Receipt Button -->
					<form name="Receipt" method="post" action="receipt.jsp" target="_blank">
						<table width ="100%">
							<tr>
								<th class=tableTextRight width="50%"><img src="images/toolbaricons/print.png" height="20"/></th>
								<th class=tableTextLeft width="50%"><input type="submit" name="Receipt" value="Print Receipt"></th>
							</tr>
						</table>
						<input name="receiptTransactionID" type="hidden" value="<% out.print(TransactionID); %>">
					</form>
				</th>
			</tr>
	<%
				}//END WHILE (PRODUCT DETAILS)
			}//END WHILE (BASKET ITEMS)
		}//END WHILE (TRANSACTION DETAILS)
	%>
		</table>
	</body>
</html>