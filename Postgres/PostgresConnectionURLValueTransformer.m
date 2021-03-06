// PostgresConnectionURLValueTransformer.m
//
// Created by Mattt Thompson (http://mattt.me/)
// Copyright (c) 2012 Heroku (http://heroku.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PostgresConnectionURLValueTransformer.h"

@implementation PostgresConnectionURLValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    NSURL *url = (NSURL *)value;
    
    return [url absoluteString];
}

@end

#pragma mark -

@implementation PostgresPSQLValueTransformer

- (id)transformedValue:(id)value {
    NSURL *url = (NSURL *)value;
    
    return [NSString stringWithFormat:@"psql -h %@ -p %@", [url host], [url port]];
}

@end

@implementation PostgresPGRestoreValueTransformer

- (id)transformedValue:(id)value {
    NSURL *url = (NSURL *)value;
    
    return [NSString stringWithFormat:@"pg_restore --verbose --clean --no-acl --no-owner -h %@ -p %@ [YOUR_DATA_FILE]", [url host], [url port]];
}

@end

@implementation PostgresActiveRecordValueTransformer

- (id)transformedValue:(id)value {
    NSURL *url = (NSURL *)value;
    
    NSMutableArray *mutableLines = [NSMutableArray array];
    [mutableLines addObject:[NSString stringWithFormat:@"adapter: %@", @"postgresql"]];
    [mutableLines addObject:[NSString stringWithFormat:@"encoding: %@", @"unicode"]];
    [mutableLines addObject:[NSString stringWithFormat:@"host: %@", [url host]]];
    [mutableLines addObject:[NSString stringWithFormat:@"port: %@", [url port]]];
    [mutableLines addObject:[NSString stringWithFormat:@"usename: %@", [url user]]];
    [mutableLines addObject:[NSString stringWithFormat:@"password:"]];
    [mutableLines addObject:[NSString stringWithFormat:@"database: %@", @"[YOUR_DATABASE_NAME]"]];
    
    return [mutableLines componentsJoinedByString:@"\n"];
}

@end

@implementation PostgresSequelValueTransformer

- (id)transformedValue:(id)value {
    return [NSString stringWithFormat:@"Sequel.connect('%@')", [[NSValueTransformer valueTransformerForName:@"PostgresConnectionURLValueTransformer"] transformedValue:value]];
}

@end

@implementation PostgresDataMapperValueTransformer

- (id)transformedValue:(id)value {
    return [NSString stringWithFormat:@"DataMapper.setup(:default, '%@')", [[NSValueTransformer valueTransformerForName:@"PostgresConnectionURLValueTransformer"] transformedValue:value]];
}

@end

@implementation PostgresDjangoValueTransformer

- (id)transformedValue:(id)value {
    NSURL *url = (NSURL *)value;
    
    NSMutableArray *mutableLines = [NSMutableArray array];
    [mutableLines addObject:@"DATABASES = {"];
    [mutableLines addObject:@"  'default': {"];
    [mutableLines addObject:[NSString stringWithFormat:@"    'ENGINE': '%@',", @"django.db.backends.postgresql_psycopg2"]];
    [mutableLines addObject:[NSString stringWithFormat:@"    'HOST': '%@',", [url host]]];
    [mutableLines addObject:[NSString stringWithFormat:@"    'PORT': '%@',", [url port]]];
    [mutableLines addObject:[NSString stringWithFormat:@"    'USER': '%@',", [url user]]];
    [mutableLines addObject:[NSString stringWithFormat:@"    'PASSWORD': '',"]];
    [mutableLines addObject:[NSString stringWithFormat:@"    'NAME': '%@',", @"[YOUR_DATABASE_NAME]"]];
    [mutableLines addObject:@"  }"];
    [mutableLines addObject:@"}"];
    
    return [mutableLines componentsJoinedByString:@"\n"];
}

@end


//@implementation PostgresJDBCURLValueTransformer
//
//- (id)transformedValue:(id)value {
//    NSURL *url = (NSURL *)value;
//    
//    return <# string #>
//}
//
//@end
//
//
//@implementation PostgresJDBCPropertiesValueTransformer
//
//- (id)transformedValue:(id)value {
//    NSURL *url = (NSURL *)value;
//    
//    return <# string #>
//}
//
//@end
//
//@implementation PostgresPHPValueTransformer
//
//- (id)transformedValue:(id)value {
//    NSURL *url = (NSURL *)value;
//    
//    return <# string #>
//}
//
//@end






