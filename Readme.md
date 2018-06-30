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


# Contributions

The base code of this library is taken from 

- https://github.com/yoolk/lazada
- https://github.com/estebanbouza/lazada