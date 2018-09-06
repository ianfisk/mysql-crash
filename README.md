# We have a crasher

MySQL crashing is a rare occurrence, so naturally I was excited when I found a query that does just that. This readme describes how to reproduce the issue while running MySQL in a docker container. Necessary SQL tidbits can be found in `init.sql`.

## Running MySQL in Docker

```
docker run --name mysql5.6 -e MYSQL_ALLOW_EMPTY_PASSWORD=true -p 13306:3306 -d mysql:5.6 --default-authentication-plugin=mysql_native_password
```

The `--default-authentication-plugin=mysql_native_password` allows the server to work with MySQL Workbench 6.3.9.

## Crashing MySQL

After initializing our database by running the statements in `init.sql`, let's suppose you aren't that familiar with MySQL and you've come up with some silly query like this:

```
SELECT OwnerId FROM (
    (
        SELECT owner_id AS OwnerId
        FROM owners
    ) UNION (
        SELECT owner_id AS OwnerId
        FROM pets
        WHERE name = 'Remy'
    ) ORDER BY (
        SELECT MAX(v.vaccination_date)
        FROM owners
        INNER JOIN pets AS p ON p.owner_id = owners.owner_id
        INNER JOIN vaccinations AS v ON v.pet_id = p.pet_id
        WHERE owner.name = 'Ian'
    ) DESC
) AS OwnerIds;
```

But you happen to have misspelled the table name in the where clause of the order by query (`owner.name` should by `owners.name`). Referencing a table that does not exist in this subquery causes MySQL to crash**.

** I haven't been able to find the official bug report for this issue, but it looks like it has been fixed in MySQL 8. Running the same query in MySQL 8 yields the error `ERROR 1054 (42S22): Unknown column 'owner.name' in 'where clause'`.
