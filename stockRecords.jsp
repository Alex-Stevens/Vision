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
		<title>Vision: Stock Records</title>
		<link rel="stylesheet" type="text/css" href="Styles.css" />
	</head>
	
	<body>
	<%
		NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK); 
	%>
		
		<!-- Standard Links -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRight> 			<a href="shoppingBasket.jsp"><img src="images/toolbaricons/shoppingBasket.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="shoppingBasket.jsp">Shopping Basket</a></th>
				<th class=tableRight> 			<a href="homePage.jsp"><img src="images/toolbaricons/find.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="homePage.jsp">Find a Product</a></th>
				<th class=tableRightActive> 	<img src="images/toolbaricons/stockRecords.png" height="40"/></th>
				<th class=tableLeftActive> 		Stock Records
				<th class=tableRight> 			<a href="transactionRecords.jsp"><img src="images/toolbaricons/transactionRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="transactionRecords.jsp">Transaction Records</a></th>
			</tr>
		</table>
						
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Current Stock Value: <% out.print(format.format(db.currentStockValue())); %></th>
			</tr>
		</table>
				
		</br>
	<% 
		//======================================================================
		//DECISION
		//======================================================================
		
		int action = 1; //BY DEFAULT, ASSUME JUST LOADING ALL RECORDS
		
		//CHECK IF LOADING AN INDIVIDUAL ITEM
		String viewInSRProdIDStrin = request.getParameter("viewInSRProdID");
		int viewInSRProdID = 1;
			
		if (viewInSRProdIDStrin != null)
		{
			//IF SO, SET PAGE TO DISPLAY JUST 1 ITEMS DETAILS AND CONVERT FROM STRING TO INT
			action = 0;
			viewInSRProdID = Integer.parseInt(viewInSRProdIDStrin);
		}
		
		//LOADING JUST ONE ITEM
		if (action == 0)
		{
	%>
		<table width="100%" border="1">
			<tr>
				<th width="20%">Image</th>
				<th width="60%">Product Details</th>
				<th width="20%">Controls</th>
			</tr>
			
	<%
			//GET PRODUCT DETAILS
			ResultSet viewingInSR = db.findByID(viewInSRProdID);
			
			while (viewingInSR.next())
			{					
				BigDecimal SRSalePrice				=				new BigDecimal(viewingInSR.getString("SalePrice"));
				BigDecimal SRProductQuantity		=		 		new BigDecimal (viewingInSR.getString("ProductQuantity"));
				BigDecimal SROverallWorth			=				SRSalePrice.multiply(SRProductQuantity);
				
				String SRSalePriceFormatted 		= 				format.format(viewingInSR.getFloat("SalePrice"));
				String SRPurchaseCostFormatted 		= 				format.format(viewingInSR.getFloat("PurchaseCost"));
				String SROverallWorthFormatted		=				format.format(SROverallWorth);
	%>
			
			<tr>
				<!-- Image column -->
				<th width="20%" height="100">
					<img src="<%out.print(viewingInSR.getString("Image"));%>" alt="<% out.print(viewingInSR.getString("Image")); %>"  height="150" />
				</th>
				
				<!-- Product Details column -->
				<th>
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(viewingInSR.getString("ProductName")); %></th>
							<th  width="34%"><% out.print("Product ID: " + viewInSRProdID); %></th>			
						</tr>
						
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(viewingInSR.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(viewingInSR.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(viewingInSR.getString("Category")); %></th>
						</tr>
						<tr>
							<th width="33%">Supplier: <% out.print(viewingInSR.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(viewingInSR.getDate("RestockDate")); %></th>
						</tr>
					
					</table>
				</br><% out.print(viewingInSR.getString("Information")); %>
				</th>
				
				<!-- Controls Column -->
				<th width="20%">
					<form name="controls" method="post" action="productPage.jsp">
						<input name="stockRecordsProductID" type="hidden" value="<%out.print(viewInSRProdID);%>">
						<table width="100%">
							<tr>
								<th class=alignRight width="30%"><img src="images/toolbaricons/edit.png" height="40"/></th>
								<th class=alignLeft width="70%"><input type="submit" name="Edit" value="Edit Product Details"></th>
							</tr>
						</table>
					</form>
				
					Sale Price: <% out.print (SRSalePriceFormatted); %>  			</br>
					Purchase Cost: <% out.print (SRPurchaseCostFormatted); %> 		</br>
					Product Quantity: <% out.print (SRProductQuantity); %>       	</br>
					Overall Worth: <% out.print (SROverallWorthFormatted); %>
				</th>
				
			</tr>
	<%
			}	//END WHILE (RETRIEVING PRODUCT DETAILS)
	%>
	
			</table>
	<%
		}//END ACTION 0 (RETRIEVING A SINGLE ITEM'S DETAILS)
		
		if (action == 1) //DISPLAY ALL ITEMS
		{
		
		//=====================================================
		//DECISIONS
		//=====================================================
			
			//=======================================================================================================
			//UPDATE A PRODUCT
			//=======================================================================================================
			String AttemptToUpdate	= request.getParameter("AttemptToUpdate");
			String ImageDB			= request.getParameter("Image");
			String ProductIDDB		= request.getParameter("ProductID");	
			String ProductNameDB	= request.getParameter("ProductName");
			String BrandDB			= request.getParameter("Brand");
			String RangeDB			= request.getParameter("Range");
			String SupplierDB		= request.getParameter("Supplier");
			String RestockDateDB	= request.getParameter("RestockDate");
			String SalePriceDB		= request.getParameter("SalePrice");
			String PurchaseCostDB	= request.getParameter("PurchaseCost");
			String CategoryDB		= request.getParameter("Category");
			String ProductQuantityDB= request.getParameter("ProductQuantity");
			String InformationDB	= request.getParameter("Information");
			
			//DETERMINE WHETHER THE IMAGE IS BEING UPDATED 
			if (AttemptToUpdate != null && AttemptToUpdate != "")
			{
				if (ProductIDDB != "" && ProductNameDB != "" && BrandDB != "" && RangeDB != "" && SupplierDB != "" && RestockDateDB != "" && SalePriceDB != "" && PurchaseCostDB != "" && CategoryDB != "" && ProductQuantityDB != "" &&	InformationDB != "")
				{
					//INCLUDE IMAGE IN UPDATE
					if (ImageDB != null && ImageDB != "" )
					{
						try
						{
							db.updateProductDetails(ImageDB, ProductIDDB, ProductNameDB, BrandDB, RangeDB, SupplierDB, RestockDateDB, SalePriceDB, PurchaseCostDB, CategoryDB, ProductQuantityDB, InformationDB);
	%>					
							<div class=error>Changes confirmed</div>
	<%
						}
						catch(Exception e)
						{
	%>
							<div class=error>You entered a field incorrectly</div>
	<%
						}
					}
					//EXCLUDE IMAGE IN UPDATE
					else
					{
						try
						{
							db.updateProductDetailsExImage(ProductIDDB, ProductNameDB, BrandDB, RangeDB, SupplierDB, RestockDateDB, SalePriceDB, PurchaseCostDB, CategoryDB, ProductQuantityDB, InformationDB);
	%>					
						<div class=error>Changes confirmed</div>
	<%
						}
						catch(Exception e)
						{
	%>
							<div class=error>You entered a field incorrectly</div>
	<%
						}
					}
				}
				else
				{
	%>
					<div class=error>You have not entered details into all fields</div>
	<%
				}
			}
			//=====================================================================================================
			//ADD A PRODUCT
			//=====================================================================================================
			
			String AttemptToAdd			= request.getParameter("AttemptToAdd");			
			String ImageAdd				= request.getParameter("ImageAdd");	
			String ProductNameAdd		= request.getParameter("ProductNameAdd");
			String BrandAdd				= request.getParameter("BrandAdd");
			String RangeAdd				= request.getParameter("RangeAdd");
			String SupplierAdd			= request.getParameter("SupplierAdd");
			String RestockDateAdd		= request.getParameter("RestockDateAdd");
			String SalePriceAdd			= request.getParameter("SalePriceAdd");
			String PurchaseCostAdd		= request.getParameter("PurchaseCostAdd");
			String CategoryAdd			= request.getParameter("CategoryAdd");
			String ProductQuantityAdd	= request.getParameter("ProductQuantityAdd");
			String InformationAdd		= request.getParameter("InformationAdd");
			
			//ENSURE ALL DETAILS WHERE ADDED
			if (AttemptToAdd != null && AttemptToAdd != "")
			{
				if (ImageAdd != "" && ProductNameAdd != "" && BrandAdd != "" && RangeAdd != "" && SupplierAdd != "" && RestockDateAdd != "" && SalePriceAdd != "" && PurchaseCostAdd != "" && CategoryAdd != "" && ProductQuantityAdd != "" && InformationAdd != "")
				{
					try
					{
						db.addNewProduct(ImageAdd, ProductNameAdd, BrandAdd, RangeAdd, SupplierAdd, RestockDateAdd, SalePriceAdd, PurchaseCostAdd, CategoryAdd, ProductQuantityAdd, InformationAdd);
	%>
						<div class=error>Product added</div>
	<%
					}
					catch(Exception e)
					{
	%>
						<div class=error>You entered a field incorrectly</div>
	<%
					}
				}
				else
				{
	%>
				<div class=error>You have not entered details into all fields</div>
	<%
				}
			}
			
			//=======================================================================
			//DELETE A PRODUCT
			//=======================================================================
			
			String deleteProductIDStrin = request.getParameter("deleteProductID");
			
			if (deleteProductIDStrin != null && deleteProductIDStrin != "")
			{
				int deleteProductID = Integer.parseInt(deleteProductIDStrin);
				db.deleteProduct(deleteProductID);
	%>
						<div class=error>Product deleted</div>
	<%
			}
	%>	
	
		<!-- ADD PRODUCT BUTTON -->
		<form name="AddProductButton" method="post" action="addProductPage.jsp">
			<table width="100%">
				<tr>
					<th class="alignLeft" width="4%"><img src="images/toolbaricons/add.png" height="40"/></th>
					<th class="alignLeft" width="96%"><input type="submit" name="Edit" value="Add Product">
				</tr>
			</table>
		</form>	
			
		<table width="100%" border="1">
			<tr>
				<th width="20%">Image</th>
				<th width="60%">Product Details</th>
				<th width="20%">Controls</th>
			</tr>
			
	<%
			ResultSet stockRecords = db.getStockRecords();
			while (stockRecords.next())
			{
				BigDecimal SalePrice				=				new BigDecimal(stockRecords.getString("SalePrice"));
				BigDecimal ProductQuantity			=		 		new BigDecimal (stockRecords.getString("ProductQuantity"));
				BigDecimal OverallWorth				=				SalePrice.multiply(ProductQuantity);
					
				String SalePriceFormatted 			= 				format.format(stockRecords.getFloat("SalePrice"));
				String PurchaseCostFormatted 		= 				format.format(stockRecords.getFloat("PurchaseCost"));					
				String OverallWorthFormatted		=				format.format(OverallWorth);
		%>
			
			<tr>
				<!-- Image column -->
				<th width="20%" height="100">
					<img src="<%out.print(stockRecords.getString("Image"));%>" alt="<% out.print(stockRecords.getString("Image")); %>"  height="150" />
				</th>
				
				<th>
					<!-- Product Details column -->
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(stockRecords.getString("ProductName")); %></th>
							<th  width="34%"><% out.print("Product ID: " + stockRecords.getString("ProductID")); %></th>
						</tr>
		
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(stockRecords.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(stockRecords.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(stockRecords.getString("Category")); %></th>
						</tr>
		
						<tr>
							<th width="33%">Supplier: <% out.print(stockRecords.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(stockRecords.getDate("RestockDate")); %></th>
						</tr>
		
					</table>
					</br><% out.print(stockRecords.getString("Information")); %>
				</th>
				
				<!-- Controls column -->
				<th width="20%" height="100">
					<form name="controls" method="post" action="productPage.jsp">
						<input name="stockRecordsProductID" type="hidden" value="<%out.print(stockRecords.getString("ProductID"));%>">
						<table width="100%">
							<tr>
								<th class=alignRight width="30%"><img src="images/toolbaricons/edit.png" height="40"/></th>
								<th class=alignLeft width="70%"><input type="submit" name="Edit" value="Edit Product Details"></th>
							</tr>
						</table>
					</form>
					
					Sale Price: <% out.print (SalePriceFormatted); %>  			</br>
					Purchase Cost: <% out.print (PurchaseCostFormatted); %> 	</br>
					Product Quantity: <% out.print (ProductQuantity); %>        </br>
					Overall Worth: <% out.print (OverallWorthFormatted); %>
				</th>
				
			</tr>
	<%
			}//END WHILE LOOP (PRODUCT DETAILS)
	%>
		</table>

	<%
		}// END ACTION 1 (MULTIPLE PRODUCTS)
	%>
	
	</body>
</html>