import mysql from "mysql2/promise";
import { createClient } from "redis";
import express from "express";

const connection = await mysql.createConnection({
  host: "proxysql.proxysql.svc.cluster.local",
  user: "example_app_express",
  password: process.env.DATABASE_PASSWORD,
  database: "example_app_express",
  port: 6033, // Make sure this matches the ProxySQL MySQL port
});

// Redis connection (via HAProxy)
const redisPrefix = "app-example:";
const redisClient = createClient({
  url: `redis://:${process.env.VALKEY_PASSWORD}@haproxy-service.default.svc.cluster.local:6379`,
});

redisClient.on("error", (err) => console.error("Redis Client Error", err));
await redisClient.connect();
console.log("Connected to Redis proxy.");

const app = express();
const port = 3000;

// Helper function to handle MySQL queries with async/await
const executeQuery = async (query, values = []) => {
  try {
    const [rows] = await connection.query(query, values);
    return rows;
  } catch (error) {
    throw new Error("MySQL query failed: " + error.message);
  }
};

app.get("/", async (req, res) => {
  try {
    console.log("GET /");
    const createTableQuery = `
    CREATE TABLE IF NOT EXISTS counter_table (
      id INT AUTO_INCREMENT PRIMARY KEY,
      counter INT NOT NULL
    )
  `;

    // SQL query to insert the initial value if the table is empty
    const insertInitialValueQuery = `
    INSERT INTO counter_table (counter) 
    SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM counter_table)
  `;

    // SQL query to update the counter value
    const updateCounterQuery = `
    UPDATE counter_table
    SET counter = counter + 1
    ORDER BY id DESC
    LIMIT 1
  `;

    // SQL query to fetch the updated counter value
    const fetchCounterQuery = `
    SELECT counter FROM counter_table ORDER BY id DESC LIMIT 1
  `;

    // MySQL queries
    await executeQuery(createTableQuery);
    await executeQuery(insertInitialValueQuery);
    await executeQuery(updateCounterQuery);
    const dbResults = await executeQuery(fetchCounterQuery);
    const dbCounter = dbResults[0].counter;

    // Redis operations
    let redisCounter = await redisClient.get(redisPrefix + "redisCounter");
    redisCounter = redisCounter ? parseInt(redisCounter) : 0;

    await redisClient.set(redisPrefix + "redisCounter", redisCounter + 1);

    res.send(`MySQL Counter: ${dbCounter}, Redis Counter: ${redisCounter + 1}`);
  } catch (error) {
    console.error(error.message);
    res.status(500).send("An error occurred");
  }
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
