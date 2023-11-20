I want to add an IFrame to a page so that I can display and interact with an external web site.

--

The intent of the component is to provide the ability to embed an external web site in an IFrame on a page of a Business Unit's web site. The component can optionally append a query string to the external web site's URL to provide information about the Business Unit user that's viewing the IFrame. This allows the external web site to change its behaviour based on this Business Unit user. The query string is encoded to avoid it being casually inspected.

The parameters to the component are as follows :

	Source URL
		The URL pointing to the external web site

	Embed width
		The width of the IFrame on the page

	Embed height
		The height of the IFrame on the page

	IFrame alignment
		How the IFrame should be horizontally aligned (left, center, or right)

	Append query string with user data
		Optionally append Salesforce user information to the source Url as a query string

	User order check type
		Indicates the time range within which a user may have placed an order 

		The types available are (using 2023/11/15 as an example date):

			in-current-year
				Order occurred sometime this year, (2023/01/01 - 2023/11/15)

			in-year-range
				Order occurred in a range of years (if range is one year, 2022/11/15 - 2023/11/15)

			in-current-month
				Order occurred sometime this month, up to today's date (2023/11/01 - 2023/11/15)

			in-given-month
				Order only count if it occurred in given month (if given month is 12, 2023/12/01 - 2023/12/15)

			today
				Order occurred on today's date (2023/11/15)

			today-in-given-month
				Order occurred on today's date in given month (if given month is 12, 2023/12/15)

			yesterday-and-today
				Order occurred on today's date or the previous date (2023/11/14 - 2023/11/15)

			yesterday-and-today-in-given-month
				Order occurred on today's date or the previous date in given month (if given month is 12, 2023/12/14 - 2023/12/15)

	User order check: year range (1-10)
		If check is "year-range", indicate the range of years in which an order should have been placed

	User order check: specific month (1-12)
		If check is "...-in-given-month", indicate the month in which an order should have been placed

	Debug IFrame
		If checked, debug data will be displayed before the IFrame

		The following debug data are displayed:

			User Data
				Indicates current user data retrieved by component

			IFrame URL
				Displays IFrame URL used

			Query string
				If query string is to be appended, displays a copy of it

			JSON result
				Displays order history retrieved by component for currrent user

	Debug using date as 'today'
		If checked, the component will use the date configured as today's date

	Date to use as today (YYYY/MM/DD)
		Value that the component will use as today's date
 

The format of the encoded query string sent to the external web site is as follows :

	?data=...
		An encoded version of the user data

Once the value of this data is decoded, the resulting query string is as follows :

	?error=...
		An error indication, "no" = all is good, anything else indicates an error

	&id=...
		The Salesforce ID of the user

	&name=...
		The name of the Salesforce user

	&user=...
		The username of the Salesforce user

	&email=...
		The email address of the Salesforce user

	&account=...
		The account external ID of the Salesforce user

	&ordered=...
		An order placement indication, "yes" = user has placed an order within the given range, otherwise holds an error indication

	&community=...
		The Community Id of the user

	&today=...
		Value used as today's date

	&from=...
		Orders are checked starting from this date

	&to=...
		Orders are checked ending with this date

	&found=...
		Date of the order found in the date range "from"..."to"

	&check=...
		Indicates what order check type was applied

	&year=...
		If "year-range" order check type was used, indicates year range used

	&month=...
		If "...in-given-month" order check type was used, indicates given month used
