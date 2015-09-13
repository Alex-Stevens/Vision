<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="basketItem.basketItem" %>

<jsp:useBean id="db" class="com.db" scope="request">
	<jsp:setProperty name="db" property="*"/>
</jsp:useBean>

<html>
	<head>
		<title>Vision: Edit Product</title>
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
				<th class=tableRightActive>		<a href="stockRecords.jsp"><img src="images/toolbaricons/stockRecords.png" height="40"/></a></th>
				<th class=tableLeftActive>		<a href="stockRecords.jsp">Stock Records</a></th>
				<th class=tableRight> 			<a href="transactionRecords.jsp"><img src="images/toolbaricons/transactionRecords.png" height="40"/></a></th>
				<th class=tableLeft> 			<a href="transactionRecords.jsp">Transaction Records</a></th>
			</tr>
		</table>
		
		<table width="100%" border="0">
			<tr>
				<th class=tableRight> 				<img src="images/toolbaricons/add.png" height="40"/></th>
				<th class=tableLeft> 				Add Product</th>
				<th class=tableRightActive> 		<img src="images/toolbaricons/edit.png" height="40"/></th>
				<th class=tableLeftActive> 			Edit Product</th>
			</tr>
		</table>
						
		<table width="100%" border="0">
			<tr>
				<th class=statusBarRight>&nbsp;</th>
			</tr>
		</table>
				</br>
					
	<%
		//GET PRODUCT ID
		String stockRecordsProductIDString = request.getParameter ("stockRecordsProductID");
		int stockRecordsProductID = Integer.parseInt (stockRecordsProductIDString);
		
		//GET PRODUCT DETAILS
		ResultSet rs = db.findByID(stockRecordsProductID);
		
		while (rs.next())
		{
			//FORM / FIELDS
	%>
		<form name="controls" method="post" action="stockRecords.jsp">
			<table width="100%">
				<tr><th class=tableTextRight>Product ID:   		</th> <th class=tableTextLeft><input name="ProductID" readonly="readonly" value="<% out.print(stockRecordsProductID); %>"></th></tr>
				<tr><th class=tableTextRight>Product Name: 		</th> <th class=tableTextLeft><input name="ProductName" readonly="readonly" value="<% out.print(rs.getString("ProductName")); %>"></th></tr>
				<tr><th class=tableTextRight>Brand: 			</th> <th class=tableTextLeft><input name="Brand" type="text" value="<% out.print(rs.getString("Brand")); %>" ></th></tr>
				<tr><th class=tableTextRight>Range: 			</th> <th class=tableTextLeft><input name="Range" type="text" value="<% out.print(rs.getString("Range")); %>" ></th></tr>
				<tr><th class=tableTextRight>Supplier: 			</th> <th class=tableTextLeft><input name="Supplier" type="text" value="<% out.print(rs.getString("Supplier")); %>" ></th></tr>
				<tr><th class=tableTextRight>Restock Date:		</th> <th class=tableTextLeft><input name="RestockDate" type="text" value="<% out.print(rs.getDate("RestockDate")); %>" > (YYYY-MM-DD)</th></tr>
				<tr><th class=tableTextRight>Sale Price: &pound;</th> <th class=tableTextLeft><input name="SalePrice" type="text" value="<% out.print(rs.getFloat("SalePrice")); %>" ></th></tr>
				<tr><th class=tableTextRight>Purchase Cost:	&pound;	</th> <th class=tableTextLeft><input name="PurchaseCost" type="text" value="<% out.print(rs.getFloat("PurchaseCost")); %>" ></th></tr>
				<tr><th class=tableTextRight>Category: 			</th> <th class=tableTextLeft><input name="Category" type="text" value="<% out.print(rs.getString("Category")); %>" ></th></tr>
				<tr><th class=tableTextRight>Product Quantity: 	</th> <th class=tableTextLeft><input name="ProductQuantity" type="text" value="<% out.print(rs.getInt("ProductQuantity")); %>" ></th></tr>
				<tr><th class=tableTextRight>Information:		</th> <th class=tableTextLeft><input name="Information" type="text" value="<% out.print(rs.getString("Information")); %>" ></th></tr>
				<tr><th class=tableTextRight>Image: 			</th> <th class=tableTextLeft><input name="Image" type="file" </th></tr>
			</table>
			<input type="hidden" name="AttemptToUpdate" value="1">
			</br>
			
		<!-- UPDATE DETAILS BUTTON -->
			<table width="100%">
				<tr>
					<th class="alignRight" width="45%"><img src="images/toolbaricons/edit.png" height="40"/></th>
					<th class="alignRight" width="5%"><input type="submit" name="add" value="Update Product Details"></th>
		</form>
	
		<!-- DELETE BUTTON -->
		<form name="controls" method="post" action="stockRecords.jsp">
			<input type="hidden" name="deleteProductID" value="<% out.print(stockRecordsProductID); %>">
					<th class="alignRight" width="5%"><img src="images/toolbaricons/delete.png" height="40"/></th>
					<th class="alignLeft" width="45%"><input type="submit" name="delete" value="Delete Item"></th>
		</form>
				</tr>
			</table>
		<%
		} //END WHILE (PRODUCT DETAILS)
		%>

	</body>
</html>