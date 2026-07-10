SELECT * FROM pizzaanalysis.order_details LIMIT 5;
SELECT * FROM pizzaanalysis.orders LIMIT 5;
SELECT * FROM pizzaanalysis.pizza_type LIMIT 5;
SELECT * FROM pizzaanalysis.pizzas LIMIT 5;
-- Basic:

-- Retrieve the total number of orders placed.
		SELECT COUNT(*) AS total_orders FROM orders ;
-- Calculate the total revenue generated from pizza sales.
SELECT  ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales
FROM order_details 
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id;	

-- Identify the highest-priced pizza.

SELECT pizza_type_id, price FROM pizzas ORDER BY price DESC LIMIT 1;
SELECT pizza_type_id,price FROM pizzas WHERE price=(SELECT MAX(price)FROM pizzas);

-- Identify the most common pizza size ordered.
SELECT pizzas.size,COUNT(order_details.order_details_id) AS 'p count'
FROM pizzas  JOIN order_details ON pizzas.pizza_id = order_details.pizza_id 
GROUP BY pizzas.size ;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pizza_type.name,sum(order_details.quantity) as quantity ,pizzas.price
 FROM pizza_type JOIN pizzas ON pizzas.pizza_type_id=pizza_type.pizza_type_id  
 JOIN order_details ON order_details.pizza_id=pizzas.pizza_id
group by pizza_type.name,pizzas.price ORDER BY quantity DESC LIMIT 5;

-- Intermediate:

-- Join the necessary tables to find the total quantity of each pizza category ordered.
	
    select pizza_type.category,sum(order_details.quantity) as quantity
    from pizzas join pizza_type on pizza_type.pizza_type_id=pizzas.pizza_type_id   -- ACTUAL ANSWER 
    join order_details on order_details.pizza_id=pizzas.pizza_id
    group by pizza_type.category ORDER BY quantity desc ;
    
    SELECT pizza_id,SUM(quantity)  FROM order_details GROUP BY pizza_id;  -- BY PIZZA ID  
    
	SELECT order_details.pizza_id,SUM(order_details.quantity),pizzas.price    -- WITH PRICE 
    FROM order_details JOIN pizzas ON pizzas.pizza_id=order_details.pizza_id
    GROUP BY order_details.pizza_id,pizzas.price;
    
    SELECT order_details.pizza_id,SUM(order_details.quantity),pizzas.price 
    FROM order_details JOIN pizzas ON pizzas.pizza_id=order_details.pizza_id
    GROUP BY order_details.pizza_id,pizzas.price;

	-- Aggregates don't need to be in GROUP BY. we just use group by with agg function
    
	SELECT order_details.pizza_id,SUM(order_details.quantity),pizzas.price,SUM(order_details.quantity) * pizzas.price AS total_sale
    FROM order_details JOIN pizzas ON pizzas.pizza_id=order_details.pizza_id
    GROUP BY order_details.pizza_id,pizzas.price;

-- Determine the distribution of orders by hour of the day.
select hour(order_time) as hours ,count(order_id)
from orders group by hours;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
		select orders.order_date,sum(order_details.quantity) as quantity
        from orders join order_details on order_details.order_details_id=orders.order_id
        group by orders.order_date;
        
        select avg(quantity) from (select orders.order_date,sum(order_details.quantity) as quantity
        from orders join order_details on order_details.order_details_id=orders.order_id
        group by orders.order_date) as average_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
		-- HERE BOTH AGG SO NO NEED TO INC IN GROUP BY  
		SELECT order_details.pizza_id,SUM(order_details.quantity)*MAX(pizzas.price) AS total_sale
        FROM order_details JOIN pizzas ON pizzas.pizza_id=order_details.pizza_id 
        GROUP BY order_details.pizza_id ORDER BY total_sale DESC LIMIT 3;
        --  HERE PIZZAID IS STILL A COLUMN AND NOT AGG SO WE GROUP IT

-- Advanced:

-- Calculate the percentage contribution of each pizza type to total revenue.
			select pizza_type.category,
            round(sum(order_details.quantity*pizzas.price) /
            (select sum(order_details.quantity * price) from pizzas 
            join order_details on order_details.pizza_id=pizzas.pizza_id) *100,2)
            as total_sale_percent
            from pizza_type join pizzas on pizzas.pizza_type_id=pizza_type.pizza_type_id
            join order_details on order_details.pizza_id=pizzas.pizza_id
            group by pizza_type.category;
            
            -- sum(order_details.quantity*pizzas.price)      INDIVIDUAL PRICE 
            -- select sum(order_details.quantity * price) from pizzas join order_details on ordeR_details.pizza_id=pizzas.pizza_id; TOTAL REVENUE
            

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.





