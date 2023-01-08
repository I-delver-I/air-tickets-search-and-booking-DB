USE air_tickets_search_and_booking;

-- ≥нформац≥€ про попул€рн≥сть рейс≥в
SELECT f.[name], COUNT(*) AS tickets_count
FROM ticket_booking AS tb
INNER JOIN ticket AS t
	ON tb.ticket_id = t.id
INNER JOIN flight AS f
	ON f.[name] = t.flight_name
GROUP BY f.[name]
ORDER BY tickets_count;

-- 