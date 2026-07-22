use assignment;

select * from airport_data;

##1. Analyze total passenger traffic per route and over time.
select year,quarter,origin_city_name,dest_city_name,sum(passengers) as total_passenger from airport_data
group by 1,2,3,4
order by year,quarter;

##2. Determine average passengers per flight for various routes and airports.
##For Routes
select ORIGIN_CITY_NAME,DEST_CITY_NAME,airline_id,avg(passengers) as average_passenger from airport_data
group by 1,2,3
order by average_passenger desc;

##For airports
with outgoing_passenger as
(select ORIGIN_AIRPORT_ID, airline_id, avg(passengers) as average_passenger from airport_data
group by 1,2
order by average_passenger desc),

incoming_passenger as
(select DEST_AIRPORT_ID, airline_id, avg(passengers) as average_passenger from airport_data
group by 1,2
order by average_passenger desc),

all_airport as
(select DISTINCT ORIGIN_AIRPORT_ID AS airport_id from airport_data
UNION
select DISTINCT DEST_AIRPORT_ID AS airport_id from airport_data)

select a.airport_id,op.average_passenger + ip.average_passenger as total_passenger from all_airport as a
LEFT JOIN outgoing_passenger as op on a.airport_id = op.ORIGIN_AIRPORT_ID
LEFT JOIN incoming_passenger as ip on a.airport_id = ip.DEST_AIRPORT_ID
where op.average_passenger + ip.average_passenger is not null 
order by total_passenger desc;

-- 3. Assess flight frequency and identify high-traffic corridors.
select ORIGIN_CITY_NAME,DEST_CITY_NAME,count(airline_id) as total_flights from airport_data
group by 1,2
order by total_flights desc;

-- 4. Compare passenger numbers across origin cities to identify top-performing airports.
select ORIGIN_CITY_NAME,ORIGIN_AIRPORT_ID,sum(passengers) as total_passenger from airport_data
group by 1,2
order by total_passenger desc;

-- 5. Evaluate available seat capacity to understand seat utilization.
with seat_capacity as
(select airline_id,max(passengers) as max_capacity from airport_data
group by 1
order by max_capacity desc),

seat_utilization as
(select a.airline_id, a.passengers*100/sc.max_capacity as used_seats from airport_data a
join seat_capacity sc on a.airline_id = sc.airline_id
order by used_seats desc)

select airline_id,round(avg(used_seats),2) as avg_seat_utilization from seat_utilization
group by 1
order by avg_seat_utilization desc;

-- 6. Identify popular destination airports based on inbound passenger counts.
select DEST_AIRPORT_ID,sum(passengers) as total_passenger from airport_data
group by 1
order by total_passenger desc;

select * from city_population;

-- 7. Examine the relationship between city population and airport passenger traffic.
with outgoing_passenger as
(select ORIGIN_AIRPORT_ID, avg(passengers) as avg_passenger from airport_data
group by 1
order by avg_passenger desc),

incoming_passenger as
(select DEST_AIRPORT_ID, avg(passengers) as avg_passenger from airport_data
group by 1
order by avg_passenger desc),

airports as
(select distinct ORIGIN_AIRPORT_ID as airport_id,ORIGIN_CITY_NAME AS city_name from airport_data
UNION
select distinct DEST_AIRPORT_ID as airport_id, DEST_CITY_NAME AS city_name from airport_data),

passenger_traffic as
(select a.city_name, ip.avg_passenger + op.avg_passenger as total_passenger_travelling from airports as a
LEFT JOIN incoming_passenger as ip on a.airport_id=ip.DEST_AIRPORT_ID
LEFT JOIN outgoing_passenger as op on a.airport_id=op.ORIGIN_AIRPORT_ID
order by total_passenger_travelling desc)

select c.city_name,c.population,p.total_passenger_travelling from passenger_traffic as p
join city_population as c on p.city_name=c.city_name
order by population desc;

-- 8. Assess the impact of population size on flight frequency and route choices.
select * from airport_data;
select * from city_population;

with flight_frequency AS
(select ORIGIN_CITY_NAME,DEST_CITY_NAME,COUNT(airline_id) as total_flights from airport_data
group by 1,2
order by total_flights desc)

select f.total_flights,f.ORIGIN_CITY_NAME, f.DEST_CITY_NAME, cp1.population + cp2.population as total_population from flight_frequency f
left join city_population cp1 on f.ORIGIN_CITY_NAME=cp1.city_name
left join city_population cp2 on f.DEST_CITY_NAME=cp2.city_name
order by f.total_flights,total_population desc;


































with seat_capacity as (select airline_id,max(passengers) as max_capacity from airport_data group by 1 order by max_capacity desc),  seat_utilization as (select a.airline_id, a.passengers*100/sc.max_capacity as used_seats from airport_data a join seat_capacity sc on a.airline_id = sc.airline_id order by used_seats desc)  select airline_id,round(avg(seat_utilization),2) as avg_seat_utilization from seat_utilization group by 1 order by avg_seat_utilization desc
