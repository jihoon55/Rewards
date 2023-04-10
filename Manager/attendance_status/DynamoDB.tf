resource "aws_dynamodb_table" "attendance" {
  name = "Attendance"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "attendance_1" {
  table_name = aws_dynamodb_table.attendance.name
  hash_key   = aws_dynamodb_table.attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "date" : {
    "N" : "3"
  },
  "user_id" : {
    "S" : "1"
  },
})
}

resource "aws_dynamodb_table_item" "attendance_2" {
  table_name = aws_dynamodb_table.attendance.name
  hash_key   = aws_dynamodb_table.attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "date" : {
    "N" : "3"
  },
  "user_id" : {
    "S" : "3"
  },
})
}

resource "aws_dynamodb_table_item" "attendance_3" {
  table_name = aws_dynamodb_table.attendance.name
  hash_key   = aws_dynamodb_table.attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "date" : {
    "N" : "5"
  },
  "user_id" : {
    "S" : "2"
  },
})
}

resource "aws_dynamodb_table_item" "attendance_4" {
  table_name = aws_dynamodb_table.attendance.name
  hash_key   = aws_dynamodb_table.attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "4"
 }
  "date" : {
    "N" : "5"
  },
  "user_id" : {
    "S" : "4"
  },
})
}

resource "aws_dynamodb_table" "products" {
  name = "Products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "product_1" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "condition" : {
    "N" : "10"
  },
  "name" : {
    "S" : "nike"
  },
  "remain" : {
    "N" : "7"
  },  
})
}

resource "aws_dynamodb_table_item" "product_2" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "condition" : {
    "N" : "15"
  },
  "name" : {
    "S" : "adidas"
  },
  "remain" : {
    "N" : "20"
  },  
})
}

resource "aws_dynamodb_table_item" "product_3" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "condition" : {
    "N" : "15"
  },
  "name" : {
    "S" : "newbalance"
  },
  "remain" : {
    "N" : "25"
  },  
})
}

resource "aws_dynamodb_table" "rewards" {
  name = "Rewards"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "reward_1" {
  table_name = aws_dynamodb_table.rewards.name
  hash_key   = aws_dynamodb_table.rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "product_id" : {
    "N" : "3"
  },
  "reward_time" : {
    "N" : "17"
  },
  "user_id" : {
    "S" : "4"
  },  
})
}

resource "aws_dynamodb_table_item" "reward_2" {
  table_name = aws_dynamodb_table.rewards.name
  hash_key   = aws_dynamodb_table.rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "product_id" : {
    "N" : "2"
  },
  "reward_time" : {
    "N" : "15"
  },
  "user_id" : {
    "S" : "3"
  },  
})
}

resource "aws_dynamodb_table_item" "reward_3" {
  table_name = aws_dynamodb_table.rewards.name
  hash_key   = aws_dynamodb_table.rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "product_id" : {
    "N" : "1"
  },
  "reward_time" : {
    "N" : "3"
  },
  "user_id" : {
    "S" : "1"
  },  
})
}

resource "aws_dynamodb_table_item" "reward_4" {
  table_name = aws_dynamodb_table.rewards.name
  hash_key   = aws_dynamodb_table.rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "4"
 }
  "product_id" : {
    "N" : "6"
  },
  "reward_time" : {
    "N" : "7"
  },
  "user_id" : {
    "S" : "2"
  },  
})
}

resource "aws_dynamodb_table" "users" {
  name = "Users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "user_1" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "username" : {
    "S" : "sang"
  },
  "count" : {
    "N" : "3"
  },
  "user_point" : {
    "N" : "40000"
  },  
})
}

resource "aws_dynamodb_table_item" "user_2" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "username" : {
    "S" : "hoon"
  },
  "count" : {
    "N" : "5"
  },
  "user_point" : {
    "N" : "20000"
  },  
})
}

resource "aws_dynamodb_table_item" "user_3" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "username" : {
    "S" : "geon"
  },
  "count" : {
    "N" : "3"
  },
  "user_point" : {
    "N" : "30000"
  },  
})
}

resource "aws_dynamodb_table_item" "user_4" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "4"
 }
  "username" : {
    "S" : "tae"
  },
  "count" : {
    "N" : "5"
  },
  "user_point" : {
    "N" : "40000"
  },  
})
}