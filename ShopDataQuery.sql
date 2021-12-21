--find the first and latest order date of each buyer in each shop
SELECT shopid, buyerid, MIN(order_time) AS first_order, MAX(order_time) AS last_order 
FROM dbo.order_tab
GROUP BY buyerid, shopid
ORDER BY first_order, last_order 

--count the number of buyer per country
SELECT country, COUNT(u.buyerid)
FROM dbo.user_tab u
GROUP BY country

--find buyer that make more than 1 order in 1 month
select buyerid, count_order
FROM	(SELECT buyerid, COUNT(orderid) AS count_order
		FROM dbo.order_tab
		GROUP BY buyerid, MONTH(order_time)) a
WHERE count_order > 1
ORDER BY count_order ASC

--number of order per country
SELECT country, COUNT(orderid)
FROM dbo.order_tab o
INNER JOIN dbo.user_tab u ON o.buyerid = u.buyerid
GROUP BY country

--find the first buyer of each shop
SELECT shopid, buyerid
FROM dbo.order_tab
WHERE order_time IN (SELECT MIN(order_time) AS first_buyer_date
					FROM dbo.order_tab
					GROUP BY shopid)

--find the TOP 10 Buyer by GMV in Country ID & SG.
SELECT DISTINCT TOP 10 u.buyerid, o.gmv
FROM dbo.order_tab o
INNER JOIN dbo.user_tab u ON o.buyerid = u.buyerid
WHERE country LIKE 'ID'
	OR country LIKE 'SG'
ORDER BY gmv DESC, buyerid ASC

--number of buyer who made their first order in each country, each day

SELECT ex.country, ex.first_order_date, COUNT(ex.buyerid) AS numb_of_buyer
FROM	(SELECT u.country, o.buyerid, MIN(o.order_time) AS first_order_date
		FROM dbo.order_tab o
		JOIN dbo.user_tab u ON o.buyerid = u.buyerid
		GROUP BY o.buyerid, u.country) ex
GROUP BY ex.country, ex.first_order_date

--find number of buyer of each country that purchased item with even and odd itemid number
SELECT u.country, b.oddeven, COUNT(b.buyerid) AS number_of_buyer
FROM	(SELECT a.buyerid, itemid_converted, CASE 
			WHEN itemid_converted%2 = 0 THEN 'evenitem'
			ELSE 'odditem'
		END oddeven
		FROM (SELECT buyerid, CONVERT(int, itemid) AS itemid_converted
				FROM dbo.order_tab) a
		) b
INNER JOIN dbo.user_tab u ON b.buyerid = u.buyerid
GROUP BY u.country, b.oddeven
ORDER BY u.country 

--first shop GMV of each shop. If there is a tie, use the purchase with the lower orderid
SELECT shopid, gmv
FROM dbo.order_tab
WHERE order_time IN (SELECT MIN(order_time) AS first_gmv_date
					FROM dbo.order_tab
					GROUP BY shopid)

--find the number of order/views & clicks/impressions of each shop (if possible make it in 1 query)
SELECT shopid, SUM(item_views) AS number_of_views, SUM(total_clicks) AS number_of_clicks
FROM dbo.performance_tab
GROUP BY shopid

--Find out what is wrong with the sample data
SELECT *
		FROM dbo.order_tab o
		JOIN dbo.user_tab u ON o.buyerid = u.buyerid
WHERE u.shopid = o.shopid 
AND u.buyerid = o.buyerid
AND order_time < register_date
