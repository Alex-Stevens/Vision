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
		
		<!-- NAVIGATION BAR -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRight> 			<a href="transactionRecords.jsp"><img src="images/toolbaricons/transactions.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="transactionRecords.jsp">Transactions</a></th>
				<th class=tableRightActive> 	<img src="images/toolbaricons/topSellers.png" height="40"/></th>
				<th class=tableLeftActive> 		Top Sellers</th>
			</tr>
		</table>
		
		<!-- STATUS BAR -->
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Next Transaction: <% out.print((session.getAttribute("transactionID")));%></th>
			</tr>
		</table>
		
		<!-- TABLE HEADERS -->
		<table width="100%" border="1">
			<tr>
				<th width="15%">Image</th>
				<th width="60%">Product Details</th>
				<th width="10%">Sale Price</th>
				<th width="5%" >Quantity Sold</th>
				<th width="10%">Subtotal</th>
			</tr>
			</br>
							
	<%
		NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK); 
		try
		{
			
			//GET BEST SELLERS
			String bs = db.bestSeller();
	
			// EXTRACT PRODUCTIDs AND QUANTITY FROM RESULT
			String [] bsArr = bs.split("/");
			int Product1ID = Integer.parseInt(bsArr[0]);
			int Product1Quant = Integer.parseInt(bsArr[1]);
			
			int Product2ID = Integer.parseInt(bsArr[2]);
			int Product2Quant = Integer.parseInt(bsArr[3]);
			
			int Product3ID = Integer.parseInt(bsArr[4]);
			int Product3Quant = Integer.parseInt(bsArr[5]);
		
			//===================================================================================================
			//PRODUCT 1
			//===================================================================================================
			//GET PRODUCT DETAILS
			ResultSet no1Details = db.findByID(Product1ID);
	
			//PRINT PRODUCT DETAILS
			while (no1Details.next())
			{			
				BigDecimal SalePrice				=				new BigDecimal(no1Details.getString("SalePrice"));
				String SalePriceFormatted 			= 				format.format(SalePrice);
				BigDecimal Subtotal 				=				SalePrice.multiply(new BigDecimal(Product1Quant));
				String SubtotalFormatted			=				format.format(Subtotal);
	%>
			
			<tr>
				<!-- Image column -->
				<th width="15%" height="100">
					<img src="<%out.print(no1Details.getString("Image"));%>" alt="<% out.print(no1Details.getString("Image")); %>"  height="150" />
				</th>
				
				<!-- Product Details column -->
				<th>
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(no1Details.getString("ProductName")); %></th>
							<th  width="34%"><% out.print("Product ID: " + Product1ID); %></th>
							<th  width="33%"></th>
							
						</tr>
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(no1Details.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(no1Details.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(no1Details.getString("Category")); %></th>
						</tr>
						<tr>
							<th width="33%">Supplier: <% out.print(no1Details.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(no1Details.getDate("RestockDate")); %></th>
						</tr>
					</table>
				</br><% out.print(no1Details.getString("Information")); %>
				</th>
				
				<!-- Sale price column -->   <th><%out.print(SalePriceFormatted); %> </th>
				<!-- Quantity sold column --><th><%out.print(Product1Quant);  %>	</th>
				<!-- Subtotal column -->     <th><%out.print(SubtotalFormatted); %> </th>
			</tr>
		
	<% 
			}
		
		//===================================================================================================
		//PRODUCT 2
		//===================================================================================================
		ResultSet no2Details = db.findByID(Product2ID);

			while (no2Details.next())
			{
				BigDecimal SalePrice				=				new BigDecimal(no2Details.getString("SalePrice"));
				String SalePriceFormatted 			= 				format.format(SalePrice);
			
				BigDecimal Subtotal 				=				SalePrice.multiply(new BigDecimal(Product2Quant));
				String SubtotalFormatted			=				format.format(Subtotal);
				
	%>
			
			<tr>
			<!-- Image column -->
				<th width="15%" height="100">
					<img src="<%out.print(no2Details.getString("Image"));%>" alt="<% out.print(no2Details.getString("Image")); %>"  height="150" />
				</th>
				
			<!-- Product Details column -->
				<th>
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(no2Details.getString("ProductName")); %></th>
							<th  width="34%"><% out.print("Product ID: " + Product2ID); %></th>
							<th  width="33%"></th>
							
						</tr>
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(no2Details.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(no2Details.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(no2Details.getString("Category")); %></th>
						</tr>
						<tr>
							<th width="33%">Supplier: <% out.print(no2Details.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(no2Details.getDate("RestockDate")); %></th>
						</tr>
					</table>
			</br><% out.print(no2Details.getString("Information")); %>
				</th>
				
				<!-- Sale price column -->   <th><%out.print(SalePriceFormatted); %> </th>
				<!-- Quantity sold column --><th><%out.print(Product2Quant);  %>	</th>
				<!-- Subtotal -->            <th><%out.print(SubtotalFormatted); %> </th>
			</tr>
	<%
			}
		
		//===================================================================================================
		//PRODUCT 3
		//===================================================================================================
		ResultSet no3Details = db.findByID(Product3ID);

			while (no3Details.next())
			{
				BigDecimal SalePrice				=				new BigDecimal(no3Details.getString("SalePrice"));
				String SalePriceFormatted 			= 				format.format(SalePrice);
			
				BigDecimal Subtotal 				=				SalePrice.multiply(new BigDecimal(Product3Quant));
				String SubtotalFormatted			=				format.format(Subtotal);	
	%>
			
			<tr>
				<!-- Image column -->
				<th width="15%" height="100">
					<img src="<%out.print(no3Details.getString("Image"));%>" alt="<% out.print(no3Details.getString("Image")); %>"  height="150" />
				</th>
				
				<!-- Product Details column -->
				<th>
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(no3Details.getString("ProductName")); %></th>
							<th  width="34%"><% out.print("Product ID: " + Product3ID); %></th>
							<th  width="33%"></th>
							
						</tr>
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(no3Details.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(no3Details.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(no3Details.getString("Category")); %></th>
						</tr>
						<tr>
							<th width="33%">Supplier: <% out.print(no3Details.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(no3Details.getDate("RestockDate")); %></th>
						</tr>
					</table>
		</br><% out.print(no3Details.getString("Information")); %>
				</th>
				
				<!-- Sale price columnn -->  <th><%out.print(SalePriceFormatted); %> </th>
				<!-- Quantity sold column --><th><%out.print(Product3Quant); %> </th>
				<!-- Subtotal column -->     <th><%out.print(SubtotalFormatted); %> </th>
			</tr>
	<%
			}//END BEST SELLERS
	%>
		</table>
	<%
		}//END TRY
		catch(Exception e)
		{
			out.print("Error");
		}
	%>

	</body>
</html>				