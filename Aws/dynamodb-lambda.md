# 🗄️ AWS DynamoDB + Lambda Function

> Create a serverless backend with DynamoDB as the database and Lambda as the API handler.
> No servers to manage — AWS scales everything automatically.

---

## What is DynamoDB + Lambda?

**DynamoDB** is a fully managed NoSQL database — you define a table, store items, and AWS handles storage, scaling, and backups.

**Lambda** is a serverless function that runs your code on demand — no EC2, no servers. You pay only when it's invoked.

Together they form a lightweight, scalable backend:

```
Client (Frontend / Postman)
  │
  ▼
Lambda Function URL  (your public HTTPS endpoint)
  │
  ▼
Lambda Function  (your code: GET / POST / DELETE logic)
  │
  ▼
DynamoDB Table  (BongoProducts — stores all data)
```

---

## Part 1: Create the DynamoDB Table

**1.** AWS Console → search **DynamoDB** → click it

**2.** Click **"Create table"**

**3.** Fill in:
- **Table name:** `BongoProducts`
- **Partition key:** `productId` → type: **String**
- Leave sort key **empty**

**4.** Under **Table settings** → select **"Default settings"**
> On-demand capacity is fine for most use cases — you only pay per request.

**5.** Click **"Create table"** ✅

Wait ~30 seconds until the table status shows **Active**.

---

## Part 2: Create the IAM Role for Lambda

Your Lambda function needs permission to read and write to DynamoDB. You grant this via an IAM Role.

**1.** AWS Console → search **IAM** → **Roles** → **"Create role"**

**2.** Trusted entity type → **AWS Service** → Use case → **Lambda** → click **Next**

**3.** Search and attach these two policies:
- `AmazonDynamoDBFullAccess`
- `AWSLambdaBasicExecutionRole`

**4.** Click **Next** → **Role name:** `BongoLambdaRole` → **"Create role"** ✅

---

## Part 3: Create the Lambda Function

**1.** AWS Console → search **Lambda** → **"Create function"**

**2.** Choose **"Author from scratch"**

**3.** Fill in:
- **Function name:** `BongoProductsHandler`
- **Runtime:** `Node.js 22.x` *(or 20.x — both support ES modules)*
- **Architecture:** `x86_64`

**4.** Under **Permissions** → expand **"Change default execution role"**
- Select **"Use an existing role"**
- Choose `BongoLambdaRole`

**5.** Click **"Create function"** ✅

---

## Part 4: Upload Your Code

**1.** Inside your Lambda function page → **Code** tab

**2.** Click **"Upload from"** → **".zip file"** → select your `lambda.zip` → click **Save**

**3.** After upload → scroll down to **Runtime settings** → click **Edit**
- **Handler:** `lambda.handler`
> This tells Lambda: *look for a file called `lambda.js` and call its `handler` export.*
> If your file were named `index.mjs` the handler would be `index.handler` instead.
- Click **Save** ✅

**4.** Click **Deploy** (orange button) ✅

---

## Part 5: Test the Lambda Function

### Test GET (fetch all products)

**1.** Click the **Test** tab → **"Create new test event"**

**2.** Fill in:
- **Event name:** `TestGET`
- **Event sharing settings:** `Private`
- **Template:** paste this JSON:

```json
{
  "requestContext": {
    "http": {
      "method": "GET"
    }
  }
}
```

**3.** Click **"Test"** → Expected response:
```json
{
  "statusCode": 200,
  "body": "[]"
}
```
> Empty array `[]` is correct — the table is empty. DynamoDB connection is working ✅

---

### Test POST (create a product)

**1.** Create another test event → **Event name:** `TestPOST`

```json
{
  "requestContext": {
    "http": {
      "method": "POST"
    }
  },
  "body": "{\"title\": \"Test Product\", \"description\": \"A cool item\", \"price\": 29.99, \"imageUrl\": \"https://example.com/img.jpg\"}"
}
```

**2.** Run it → you should get back the new product with a generated `productId`:
```json
{
  "productId": "bongo-xxxx-xxxx-xxxx",
  "title": "Test Product",
  "description": "A cool item",
  "price": 29.99,
  "imageUrl": "https://example.com/img.jpg",
  "createdAt": "2025-01-01T00:00:00.000Z"
}
```

---

### Test DELETE (remove a product)

**1.** Copy the `productId` from the POST response

**2.** Create test event → **Event name:** `TestDELETE`

```json
{
  "requestContext": {
    "http": {
      "method": "DELETE"
    }
  },
  "queryStringParameters": {
    "productId": "bongo-PASTE-YOUR-ID-HERE"
  }
}
```

**3.** Run it → Expected:
```json
{
  "message": "Product deleted successfully"
}
```

---

## Part 6: Create a Public Function URL

To call this Lambda from a browser, frontend, or tool like Postman, you need a public HTTPS URL.

**1.** Lambda function page → **Configuration** tab → **Function URL** (left sidebar)

**2.** Click **"Create function URL"**

**3.** Fill in:
- **Auth type:** `NONE` *(public access — anyone with the URL can call it)*
- Leave everything else as default

**4.** Click **Save** ✅

You'll get a URL like:
```
https://xxxxxxxxxxxx.lambda-url.us-east-1.on.aws/
```

> Your CORS headers in the Lambda code already allow requests from any origin (`*`), so frontend apps can call this directly.

---

## Part 7: Using the URL in a Real Project

When integrating this Lambda into an actual project (React, Next.js, etc.), **never hardcode the URL** in your source code. Use an environment variable instead.

### Create a `.env` file at the root of your project:

```env
REACT_APP_API_URL=https://xxxxxxxxxxxx.lambda-url.us-east-1.on.aws
# or for Next.js:
NEXT_PUBLIC_API_URL=https://xxxxxxxxxxxx.lambda-url.us-east-1.on.aws
```

### Use it in your code:

```javascript
// React
const API_URL = process.env.REACT_APP_API_URL;

// Next.js
const API_URL = process.env.NEXT_PUBLIC_API_URL;

// Fetch all products
const res = await fetch(`${API_URL}/`);
const products = await res.json();

// Create a product
await fetch(`${API_URL}/`, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ title: "New Item", price: 19.99 })
});

// Delete a product
await fetch(`${API_URL}/?productId=bongo-xxxx`, { method: "DELETE" });
```

### Add `.env` to `.gitignore`:

```
.env
.env.local
```

> ⚠️ Never commit your `.env` file to GitHub. If you deploy to Vercel, Netlify, or AWS Amplify, add the environment variable in their dashboard instead.

---

## What to Expect

| Test Result | What It Means |
|-------------|---------------|
| `statusCode: 200`, body `[]` on GET | ✅ DynamoDB connected, table is empty |
| `statusCode: 200` with product object on POST | ✅ Item created and saved to DynamoDB |
| `Runtime.ImportModuleError` | Handler name is wrong — must match your filename (e.g. `lambda.handler`) |
| `AccessDeniedException` | IAM role is missing `AmazonDynamoDBFullAccess` |
| `ResourceNotFoundException` | Table name mismatch — must be exactly `BongoProducts` |

---

## Verify Data in DynamoDB Console

After a successful POST test, confirm the item was saved:

```
AWS Console → DynamoDB → Tables → BongoProducts → "Explore table items"
```

You should see your test product listed there ✅

---

## Quick Reference

| Component | Purpose |
|-----------|---------|
| **DynamoDB Table** | NoSQL database — stores all product items |
| **IAM Role** | Grants Lambda permission to read/write DynamoDB |
| **Lambda Function** | Serverless code — handles GET, POST, DELETE requests |
| **Runtime Handler** | `lambda.handler` — tells Lambda which file and export to run |
| **Function URL** | Public HTTPS endpoint to call your Lambda from anywhere |
| **`.env` variable** | Stores the Function URL safely outside your source code |
| **CORS Headers** | Allow frontend apps on any domain to call the Lambda |
