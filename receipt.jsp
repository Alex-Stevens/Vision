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
		<title>Vision: Receipt</title>
	</head>
	<!-- Invoke print dialogue -->
	<script type="text/javascript">
		function do_onload() {
		window.print();
}
	</script>
	<body onload="do_onload();">
		
	<%
		NumberFormat format =  NumberFormat.getCurrencyInstance(Locale.UK); 
		
		//Get transaction ID which wants a receipt
		String receiptTransactionIDString = request.getParameter("receiptTransactionID");
		int receiptTransactionID = Integer.parseInt(receiptTransactionIDString);
		
		//GET RECEIPT DATA FOR THIS TRANSACTION
		ResultSet TransactionDetails = db.makeReceiptDataTransactionDetails(receiptTransactionID);
		
		//===============================================================
		//DATA
		//===============================================================
		
		//Transaction Data
		TransactionDetails.next();
		
		java.sql.Timestamp	SaleTime 		= 		TransactionDetails.getTimestamp("SaleTime");
		String SaleTimeString				= 		SaleTime.toString();
		SaleTimeString						= 		SaleTimeString.substring(0, 19);
		
		String		TotalFormatted			=		format.format(TransactionDetails.getFloat("Total"));
		String		AmountGivenFormatted	=		format.format(TransactionDetails.getFloat("AmountGiven"));
		String		ChangeDueFormatted		=		format.format(TransactionDetails.getFloat("ChangeDue"));

	%>
	
	<!-- FORMAT DATA FOR RECEIPT -->
	<!-- SALE TIME STAMP -->
	Sale Time: <% out.print (SaleTimeString); %>
	
	<!-- TABLE HEADERS -->
	<table width="50%">
		<tr>
			<th>Product Name</th>
			<th>Sale Price </th>
			<th>Quantity Sold</th>
			<th>Subtotal</th>
		</tr>
		<tr><th>&nbsp;</th></tr>
				
	<%
		//Basket Items
		ResultSet data = db.getBasketItems(receiptTransactionID);
		
		while (data.next())
		{
			
			//Product Details			
			ResultSet ProductData = db.findByID(data.getInt("ProductID"));
				
			while(ProductData.next())
			{
				BigDecimal SalePrice = new BigDecimal(ProductData.getString("SalePrice"));
				BigDecimal Subtotal = SalePrice.multiply(new BigDecimal(data.getInt("QuantitySold")));
				
				String SalePriceFormatted = format.format(SalePrice);
				String SubtotalFormatted = format.format(Subtotal);
					
	%>
			<tr>
				<th><% out.print(ProductData.getString("ProductName")); %></th>
				<th><% out.print(SalePriceFormatted); %></th>
				<th><% out.print(data.getInt("QuantitySold")); %></th>
				<th><% out.print(SubtotalFormatted); %></th>
			</tr>
	<%		
			}//END WHILE (PRODUCT DETAILS)
		}//END WHILE (BASKET ITEMS)
	%>
			<tr><th>&nbsp;</th></tr>
			<!-- TOTAL -->
			<tr>
				<th></th>
				<th></th>
				<th>Total</th>
				<th><% out.print(TotalFormatted); %></th>
			</tr>
			<!-- AMOUNT GIVEN -->
			<tr>
				<th></th>
				<th></th>
				<th>Amount Given</th>
				<th><% out.print(AmountGivenFormatted); %></th>
			</tr>
			<!-- CHANGE DUE -->
			<tr>
				<th></th>
				<th></th>
				<th>Change Due</th>
				<th><% out.print(ChangeDueFormatted); %></th>
			</tr>
		</table>
	</body>
</html>