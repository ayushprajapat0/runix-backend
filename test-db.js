import dotenv from 'dotenv';
dotenv.config({ path: 'app/.env' });
import client from "./app/configs/db.js";

async function test() {
    try {
        await client.connect();
        console.log("SUCCESS");
        await client.end();
    } catch (e) {
        console.log("FAIL", e);
    }
}
test();
