CREATE DEFINER=`user`@`localhost` FUNCTION `str_replace`(string_search TEXT CHARSET utf8, string_replace TEXT CHARSET utf8, string_subject TEXT CHARSET utf8) RETURNS text CHARSET utf8
BEGIN
    DECLARE string_output TEXT CHARSET utf8 default '';
    
    DECLARE iterator_index INT default 1;
    DECLARE iterator_index_max_value INT default 0;
    DECLARE string_search_chunk TEXT CHARSET utf8; 
    DECLARE string_replace_chunk TEXT CHARSET utf8; 
    DECLARE safe_tokenizing_character CHAR(16);
    DECLARE safe_tokenizing_character_found BOOL default FALSE;
    
    SET iterator_index_max_value = 1 + CHAR_LENGTH(string_search) - CHAR_LENGTH( REPLACE(string_search, ",", "") );
    SET string_output = string_subject;
    
    generate_safe_tokenizing_character: LOOP 

        IF safe_tokenizing_character_found IS TRUE THEN
            LEAVE generate_safe_tokenizing_character;
        END IF;
        
        SET safe_tokenizing_character = RAND();
        
        IF INSTR(string_subject, safe_tokenizing_character) = 0 THEN
            SET safe_tokenizing_character_found = TRUE;
        END IF;
    
    END LOOP generate_safe_tokenizing_character;
    
    tokenize: LOOP
    
        IF iterator_index > iterator_index_max_value THEN
            SET iterator_index = 1;
            LEAVE tokenize;
        END IF;
        
        SET string_search_chunk = SUBSTRING_INDEX( SUBSTRING_INDEX(string_search, ',', iterator_index), ',', -1 );
        SET string_replace_chunk = CONCAT('<', safe_tokenizing_character, iterator_index, safe_tokenizing_character, '>');

        SET string_output = REPLACE(string_output, string_search_chunk, string_replace_chunk);

        SET iterator_index = iterator_index + 1;
    
    END LOOP tokenize;
    
    replace_tokenized: LOOP
    
        IF iterator_index > iterator_index_max_value THEN
            LEAVE replace_tokenized;
        END IF;
        
        SET string_search_chunk = CONCAT('<', safe_tokenizing_character, iterator_index, safe_tokenizing_character, '>');
        SET string_replace_chunk = SUBSTRING_INDEX( SUBSTRING_INDEX(string_replace, ',', iterator_index), ',', -1 );

        SET string_output = REPLACE(string_output, string_search_chunk, string_replace_chunk);

        SET iterator_index = iterator_index + 1;
        
    END LOOP replace_tokenized;
    
    RETURN string_output;
END
