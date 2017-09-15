# *sql* str_replace
fixed php str_replace() as sql function

## Examples:

#### 1.

```sql 
select str_replace('a,b', 'b,c', 'abca');
```

output: `'bccb'`

#### 2. ([PHP DOCS EXAMPLE](http://php.net/manual/pl/function.str-replace.php#example-4545))
```sql 
select str_replace("%body%", "black", "<body text='%body%'>");
```
output: `'<body text=\'black\'>'`

#### 3. ([PHP DOCS EXAMPLE](http://php.net/manual/pl/function.str-replace.php#example-4545))
```sql 
select str_replace(
  CONCAT_WS(",", "fruits", "vegetables", "fiber"), 
  CONCAT_WS(",", "pizza", "beer", "ice cream"), 
  "You should eat fruits, vegetables, and fiber every day."
);
```
or
```sql 
select str_replace(
  "fruits,vegetables,fiber", 
  "pizza,beer,ice cream", 
  "You should eat fruits, vegetables, and fiber every day."
);
```
output: `'You should eat pizza, beer, and ice cream every day.'`

#### 4. ([PHP DOCS EXAMPLE](http://php.net/manual/pl/function.str-replace.php#example-4546))
Such PHP (*example of potential str_replace() gotchas*) code 
```php
<?php
$search  = array('A', 'B', 'C', 'D', 'E');
$replace = array('B', 'C', 'D', 'E', 'F');
$subject = 'A';
echo str_replace($search, $replace, $subject);
```
will end up producing output `'F'`, because as the docs says:
> Outputs F because A is replaced with B, then B is replaced with C, and so on...
> Finally E is replaced with F, because of left to right replacements.

With sql str_replace such weird behaviour will not happen

```sql 
select str_replace(
  CONCAT_WS(',', 'A', 'B', 'C', 'D', 'E'),
  CONCAT_WS(',', 'B', 'C', 'D', 'E', 'F'),
  'A' 
);
```

output: `'B'`

---

# How does it work?
```sql 
select str_replace('a,b', 'b,c', 'abca');
```

step by step:

  1. generate_safe_tokenizing_character:

    output: `0.45348525`
  
  2. tokenize:
  
    output: `'<0.4534852510.45348525><0.4534852520.45348525>c<0.4534852510.45348525>'`
  
  3. replace_tokenized:

    output: `'bccb'`


final output: `'bccb'`
