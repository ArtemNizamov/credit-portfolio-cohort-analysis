SELECT cd_clients.channel AS channel,
COUNT (DISTINCT cd_clients.client_id) AS total_clients,
COUNT (DISTINCT CASE WHEN ft_payments.days_overdue > 90 THEN cd_clients.client_id END) AS npl_90_clients,
ROUND (
COUNT (DISTINCT CASE WHEN ft_payments.days_overdue > 90 THEN cd_clients.client_id END) * 100 /
COUNT (DISTINCT cd_clients.client_id),
2 
) AS npl_90_rate_pct,
MONTH(ft_credits.issue_date) as start_month

FROM cd_clients
LEFT JOIN ft_credits ON cd_clients.client_id = ft_credits.client_id
LEFT JOIN ft_payments ON ft_credits.credit_id = ft_payments.credit_id

GROUP BY channel, MONTH(ft_credits.issue_date)

ORDER BY npl_90_rate_pct DESC;
