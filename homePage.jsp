<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="java.math.*" %>
<%@page import="basketItem.basketItem" %>
<%@page import="resultItem.resultItem" %>

<jsp:useBean id="db" class="com.db" scope="request">
	<jsp:setProperty name="db" property="*"/>
</jsp:useBean>

<jsp:useBean id="tools" class="tools.tools" scope="request">
	<jsp:setProperty name="tools" property="*"/>
</jsp:useBean>

<%
	NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK); 
	//==============================================================================
	//DECISION
	//==============================================================================
	
	String validSearch 		= request.getParameter("SearchBar");
	String supplierText 	= request.getParameter("Supplier");
	String categoryText 	= request.getParameter("Category");
	int action = 0;	 										
	
	//WAS SOMETHING TYPED INTO THE SEARCH BAR?
	if(validSearch != null)
	{
		//IF SO PROCEED FROM ACTION 1
		action = 1;
	}
%>

<html>
	<head>
		<title>Vision: Find a Product</title>
		<link rel="stylesheet" type="text/css" href="Styles.css" />
	</head>
	
	<body>
		
		<!-- Standard Links -->
		<table width="100%" border="0">
			<tr>
				<th class=tableRight> 			<a href="shoppingBasket.jsp"><img src="images/toolbaricons/shoppingBasket.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="shoppingBasket.jsp">Shopping Basket</a></th>
				<th class=tableRightActive> 	<img src="images/toolbaricons/find.png" height="40"/></th>
				<th class=tableLeftActive> 		Find a Product
				<th class=tableRight> 			<a href="stockRecords.jsp"><img src="images/toolbaricons/stockRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="stockRecords.jsp">Stock Records</a></th>
				<th class=tableRight> 			<a href="transactionRecords.jsp"><img src="images/toolbaricons/transactionRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="transactionRecords.jsp">Transaction Records</a></th>
			</tr>
		</table>
						
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>Running Total: <% out.print(format.format(db.getRunningTotal())); %></th>
			</tr>
		</table>
				
		</br>
	<% 
		//==================================================================
		//ACTION 0 - PAGE LOADED FOR FIRST TIME
		//==================================================================
		
		if(action == 0)
		{   	
	%>
		
		<!-- Start of search form -->
		<form name="SearchBox" method="post" action="homePage.jsp">	
			
			<center>
				<!-- Search bar -->
				<input type="text" name="SearchBar" value="" size="50" tabindex="0" />
				
				<!-- Supplier drop down menu -->
				<select name="Supplier">
					<option value="any">Select Supplier</option>
				
	<%
			//GET AVAILABLE SUPPLIERS FOR SEARCH TOOLS
			ResultSet Suppliers = db.getSuppliers();
				
			while (Suppliers.next())
			{
				String supplier = Suppliers.getString("Supplier");
	%>
				<option value="<% out.print(supplier); %>"><% out.print(supplier); %></option>
	<%
			}
	%>
				</select>
			
				<!-- Category drop down menu -->
				<select name="Category">
					<option value="any">Select Category</option>
				
	<%
			//GET AVAILABLE CATEGORIES FOR SEARCH TOOLS
			ResultSet Categories = db.getCategories();
		
			while (Categories.next())
			{
				String category = Categories.getString("Category");
	%>
					<option value="<% out.print(category); %>"><% out.print(category); %></option>
	<%
			}
	%>
				</select>
			
			<!-- SEARCH BUTTON -->
			<input type="submit"  name="post" value="  Search  " />
		</form>
	</center>
	
	</br>
				
	To find an item, use the search tools above.
				
		<!-- End of search FORM -->
	</br> 
	<%
		}//End action 0
	%>
		
	<%
		//==============================================================================
		//ACTION 1 - SHOW RESULTS
		//==============================================================================
		
		if(action == 1)
		{   
			//GET SEARCH RESULTS FROM POINT SCRORER
			Vector results = tools.getResultsFor(validSearch, supplierText, categoryText);			
	%>
		
		<!-- Start of search FORM -->
		<form name="SearchBox" method="post" action="homePage.jsp">	
			
			<center>
				<!-- Search bar -->
				<input type="text" name="SearchBar" value="" size="50" tabindex="0" />
				
				<!-- Supplier drop down menu -->
				<select name="Supplier" id="SearchBar">
					<option value="any">Select Supplier</option>
				
	<%
			//GET AVAILABLE SUPPLIERS FOR SEARCH TOOLS
			ResultSet Suppliers = db.getSuppliers();
				
			while (Suppliers.next())
			{
				String supplier = Suppliers.getString("Supplier");
	%>
					<option value="<% out.print(supplier); %>"><% out.print(supplier); %></option>
	<%
			}
	%>
				</select>
			
				<!-- Category drop down menu begin -->
				<select name="Category" id="SearchBar">
					<option value="any">Select Category</option>
				
	<%		//GET AVAILABLE CATEGORIES FOR SEARCH TOOLS
			ResultSet Categories = db.getCategories();
				
			while (Categories.next())
			{
				String category = Categories.getString("Category");
	%>
					<option value="<% out.print(category); %>"><% out.print(category); %></option>
	<%
			}
	%>
				</select>
			
			<!-- SEARCH BUTTON -->
			<input type="submit"  name="post" value="  Search  " />
		</form>
	</center>
	</br>
		
	<!-- End of search FORM -->
		
	<!-- Confirm query -->
	<div class=searchEntered>Search results for: "<% out.print(validSearch); %>" Supplier "<% out.print(supplierText); %>" Category "<% out.print(categoryText); %>"</div> </br>
		
		
	<%
			//IF THERE ARE NO RESULTS TO DISPLAY
			if (results.size() == 0) 
			{
				//SHOW ERROR MESSAGE
	%>
				<div class=error>No Results To Display</div>
	<%		}
			else
			{
	%>
		
	<!-- Begin TABLE -->
	<table  width="100%" border="1"> 
			
	<!-- Table headers -->
		<tr>
			<th width="5%">Score</th>
			<th width="20%" scope="col">Image</th>
			<th width="55%" scope="col">Product Details</th>
			<th width="20%" scope="col">Controls</th>
		</tr>
			
	<!-- Table Results -->
	<%
				//LOOP THROUGH RESULTS
				for (int t = 0; t < results.size(); t++)
				{
					//TAKE RESULT ITEM OUT OF RESULTS
					resultItem item = (resultItem)(results.get(t));
					
					//TAKE PRODUCT ID AND SCORE OUT OF RESULT ITEM
					int riProductID = item.getProductID();
					int riScore = item.getScore();
						
					ResultSet rs = db.findByID(riProductID);
							
					while (rs.next())
					{
						String Image 						= rs.getString("Image");
						String SalePriceFormatted 			= format.format(rs.getFloat("SalePrice"));
						String PurchaseCostFormatted 		= format.format(rs.getFloat("PurchaseCost"));
						int ProductQuantity 				= rs.getInt	("ProductQuantity");
						Vector shoppingBasket 				= (Vector)(session.getAttribute ("shoppingBasket"));
							
						//Check if quantity level has changed as item is in shoppingBasket
						for (int i = 0; i < shoppingBasket.size(); i++)
						{
							basketItem bI = (basketItem)(shoppingBasket.get(i));
														
							if (bI.getProductID() == riProductID)
							{
								ProductQuantity = bI.getQuantityNowAvailable();
							}
						}
	%>
			
			<tr>
				<!-- Score column -->
				<th><% out.print (riScore); %></th>
	
				<!-- Image column -->
				<th width="20%" height="100">
					<img src="<%out.print(Image);%>" alt="<% out.print(Image); %>" height="150" />
				</th>
					
				<!-- Product Details column -->
				<th>
					<table class=DetailsTable>
						<tr>
							<th  class=ProductName width="33%"><% out.print(rs.getString("ProductName")); %></th>
							<th  width="34%"><% out.print("Product ID: " + riProductID); %></th>
							
							<th  width="33%">
								<form name="viewInSR" method="post" action="stockRecords.jsp">
									<input name="viewInSRProdID" type="hidden" value="<%out.print(riProductID);%>">
										<table width="100%">
											<tr>
												<th class=alignRight width="25%"><img src="images/toolbaricons/stockRecords.png" height="20"/></th>
												<th class=alignLeft width="75%"><input type="submit" name="add" value="View in Stock Records">
											</tr>
										</table>
								</form>
							</th>
						</tr>
						
						<tr>
							<th class=DetailsTableItem>Brand: <% out.print(rs.getString("Brand")); %></th>
							<th class=DetailsTableItem>Range: <% out.print(rs.getString("Range")); %></th>
							<th class=DetailsTableItem>Category: <% out.print(rs.getString("Category")); %></th>
						</tr>
						
						<tr>
							<th width="33%">Supplier: <% out.print(rs.getString("Supplier")); %></th>
							<th width="34%">Restock Date: <% out.print(rs.getDate("RestockDate")); %></th>
						</tr>
						
					</table>
					</br>
						
					<% out.print(rs.getString("Information")); %>
						
				</th>
					
				<!-- Controls column -->
				<th width="20%" height="100">
					<div class=ProductName >Sale Price <% out.print(SalePriceFormatted); %> </div>
					Purchase Cost <% out.print(PurchaseCostFormatted); %>
					
					</br></br>
					
					<form name="controls" method="post" action="shoppingBasket.jsp">
						Quantity:
						<input name="AddItemQuantity" type="text" value="1" size="1" maxlength="2">
						<input name="AddItemProductID" type="hidden" value="<%out.print(riProductID);%>">
					
						</br>
					
						<% out.print(ProductQuantity); %> available
				
						</br></br>
						<table width="100%">
							<tr>
								<th class=alignRight width="35%"><img src="images/toolbaricons/addToBasket.png" height="20"/></th>
								<th class=alignLeft width="65%"><input type="submit" name="add" value="Add to Basket"></th>
							</tr>
						</table>
					</form>
				</th>
			</tr>
			
			<!-- END repeating results -->
	<%
					} //END WHILE (PRODUCT DETAILS LOOP)
				} //END FOR (RESULTS LOOP)
	%>
			
	</table>

	<%
			}//END ELSE (WHERE THERE RESULTS TO DISPLAY?)
		} //END ACTION 1
	%>
		
	</body>
</html>
