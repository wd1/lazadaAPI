# Lazada Open API

This gem is a wrapper for lazada open API open.lazada.com

See the `develop` branch for progress.

# Status
The following APIs have been tested to be working:

| API | Supported parameters | Status | 
| ------| ----- | :----:| 
| `/products/get` | `filter, limit, offset` | Tested and Working  |
| `/orders/get` | `status, created_after, limit, offset, sort_by, sort_direction` | Tested and Working |
| `/order/get` | `order_id` | Tested and Working |
| `/order/items/get` | `order_id` | Tested and Working |
| `/orders/items/get` | `order_ids` | Tested and Working |
| `/brands/get` | `offset`, `limit` | Tested and Working |
| `/product/create` | | Not tested |
| `/product/update`| `payload (product)` | Tested and Working |
| `/image/migrate` | `url` | Tested and Working | 
| `/images/migrate` | `urls` | Tested and Working | 
| `/image/upload` | | Not tested | 


# Quickstart

Create a client with

```
client_auth = Lazada::Client.new(
   app_key, 
   app_secret,
   tld: '.sg',
   redirect_url: 'my-redirect.com',
   use_access_token: false
)
```

Create an access token with the following steps:

a. Take the user to the sign in URL
```
client_auth.lazada_sign_in_url

```

b. After sign in, the user will be redirected to `myredirect.com/?code=<oauth_code>`. Use it to create an access token

```
response = client_auth.create_access_token(oauth_code)
```
The response contains the `access_token` and `refresh_token.` You can use them in following requests like 

```
client = Lazada::Client.new(
    app_key,
    app_secret,
    tld: '.sg',
    timezone: Time.zone,
    access_token: access_token,
)
```

# Contributions

The base code of this library is taken from 

- https://github.com/yoolk/lazada
- https://github.com/estebanbouza/lazada