<html>
	<head>
		<title>Vision: Add Product</title>
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
				<th class=tableRightActive> 		<img src="images/toolbaricons/add.png" height="40"/></th>
				<th class=tableLeftActive> 			Add Product</th>
				<th class=tableRight> 				<img src="images/toolbaricons/edit.png" height="40"/></th>
				<th class=tableLeft> 				Edit Product</th>
			</tr>
		</table>
				</br>
		
		<!-- FORM / FIELDS -->
		<form name="controls" method="post" action="stockRecords.jsp">
			<table width=100%>
				<tr><th class=tableTextRight>Product Name: 			</th> <th class=tableTextLeft><input name="ProductNameAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Brand: 				</th> <th class=tableTextLeft><input name="BrandAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Range: 				</th> <th class=tableTextLeft><input name="RangeAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Supplier: 				</th> <th class=tableTextLeft><input name="SupplierAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Restock Date:			</th> <th class=tableTextLeft><input name="RestockDateAdd" type="text"> (YYYY-MM-DD)</th></tr>
				<tr><th class=tableTextRight>Sale Price: &pound;	</th> <th class=tableTextLeft><input name="SalePriceAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Purchase Cost:	&pound;	</th> <th class=tableTextLeft><input name="PurchaseCostAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Category: 				</th> <th class=tableTextLeft><input name="CategoryAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Product Quantity: 		</th> <th class=tableTextLeft><input name="ProductQuantityAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Information:			</th> <th class=tableTextLeft><input name="InformationAdd" type="text"></th></tr>
				<tr><th class=tableTextRight>Image: 				</th> <th class=tableTextLeft><input name="ImageAdd" type="file" %></th></tr>
			</table>	
			<input type="hidden" name="AttemptToAdd" value="1">
	</br>
			<table width="100%">
				<tr>
					<th class=tableTextRight><img src="images/toolbaricons/add.png" height="40"/></th>
					<th class=tableTextLeft><input type="submit" name="add" value="Add Product"></th>
				</tr>
			</table>
		</form>
		
	</body>
</html>