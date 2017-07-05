//
//  KeyChainWrapper+PrivateMethods.m
//  PortretOn
//
//  Created by Pavel Bochilo on 04.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "KeyChainWrapper+PrivateMethods.h"

static const UInt8 kKeychainItemIdentifier[]    = "com.apple.dts.KeychainUI\0";
@implementation KeyChainWrapper (PrivateMethods)

@end


@implementation KeyChainWrapper

@synthesize keychainData, genericPasswordQuery;

- (id)init
{
    if ((self = [super init])) {
        
        OSStatus keychainErr = noErr;
        // Инициализируем keychain словарь поиска:
        genericPasswordQuery = [[NSMutableDictionary alloc] init];
        // Этот элемент keychain общий пароль.
        [genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword
                                 forKey:(__bridge id)kSecClass];
        //  kSecAttrGeneric атрибут используется для хранения уникальной строки, используемой
        // для идентификации и поиска этого keychain элемента. Сначала строку конвертируем
        // в NSData объект:
        NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                                length:strlen((const char *)kKeychainItemIdentifier)];
        [genericPasswordQuery setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
        // Возвращаем атрибуты только для первого вхождения:
        [genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        // Возвращаем атрибуты keychain элемента (пароль
        //  полученный в secItemFormatToDictionary: методе):
        [genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue
                                 forKey:(__bridge id)kSecReturnAttributes];
        
        //Инициализация словаря, используемого для хранения возвращаемых данных из keychain:
        CFMutableDictionaryRef outDictionary = nil;
        // Если keychain элемент существует, возвращаем атрибуты элемента:
        keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery,
                                          (CFTypeRef *)&outDictionary);
        if (keychainErr == noErr) {
            // Конвертируем словарь с данными в словарь, используемый контроллером вида:
            self.keychainData = [self secItemFormatToDictionary:(__bridge_transfer NSMutableDictionary *)outDictionary];
        } else if (keychainErr == errSecItemNotFound) {
            // Кидаем значения по умолчанию в keychain если нет соответствующего
            // keychain элемента:
            [self resetKeychainItem];
            if (outDictionary) CFRelease(outDictionary);
        } else {
            // Любая другая неожиданная ошибка.
            NSAssert(NO, @"Serious error.\n");
            if (outDictionary) CFRelease(outDictionary);
        }
    }
    return self;
}


// Реализация метода mySetObject:forKey, который записывает атрибуты в keychain:
- (void)mySetObject:(id)inObject forKey:(id)key
{
    if (inObject == nil) return;
    id currentObject = [keychainData objectForKey:key];
    if (![currentObject isEqual:inObject])
    {
        [keychainData setObject:inObject forKey:key];
        [self writeToKeychain];
    }
}

// Реализация метода myObjectForKey:, который значения атрибутов из словаря:
- (id)myObjectForKey:(id)key
{
    return [keychainData objectForKey:key];
}


// Сброс значений в элементе keychain или создание нового элемента, если он
// не существует:
- (void)resetKeychainItem
{
    if (!keychainData) //Создание keychainData словаря, если не существует.
    {
        self.keychainData = [[NSMutableDictionary alloc] init];
    }
    else if (keychainData)
    {
        // Форматируем данные из keychainData словаря в формат, требуемый для вызовов
        //  и кладем их в tmpDictionary:
        NSMutableDictionary *tmpDictionary =
        [self dictionaryToSecItemFormat:keychainData];
        // Удаляем keychain элемент в ходе подготовки к сбросу значений:
        OSStatus errorcode = SecItemDelete((__bridge CFDictionaryRef)tmpDictionary);
        NSAssert(errorcode == noErr, @"Problem deleting current keychain item." );
    }
    
    // Общие данные, по умолчанию, для Keychain элемента:
    [keychainData setObject:@"Item label" forKey:(__bridge id)kSecAttrLabel];
    [keychainData setObject:@"Item description" forKey:(__bridge id)kSecAttrDescription];
    [keychainData setObject:@"Account" forKey:(__bridge id)kSecAttrAccount];
    [keychainData setObject:@"Service" forKey:(__bridge id)kSecAttrService];
    [keychainData setObject:@"Your comment here." forKey:(__bridge id)kSecAttrComment];
    [keychainData setObject:@"password" forKey:(__bridge id)kSecValueData];
}

// Реализация метода dictionaryToSecItemFormat:, который принимает атрибуты, которые
// вы хотите добавить в keychain элемент и устанавливает словарь в формат
// пригодный для Keychain Services:
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    // Этот метод должен быть вызван с правильно заполненным словарем,
    // содержащим все правильные пары ключ/значение для keychain элемента.
    
    // Создаем словарь для возвращения:
    NSMutableDictionary *returnDictionary =
    [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Добавляем keychain элемент класс и общий атрибут:
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                            length:strlen((const char *)kKeychainItemIdentifier)];
    [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    // Конвертируем пароль из NSString в NSData чтобы соответствовать API Keychain:
    NSString *passwordString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding]
                         forKey:(__bridge id)kSecValueData];
    return returnDictionary;
}

// Реализация метода secItemFormatToDictionary:, который принимает словарь атрибутов
//  получаемый из элемента keychain, получает пароль из keychain, и
//  добавляет его в словарь атрибутов:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    // Данный метод должен вызываться с правильно заполненным словарем,
    // содержащим корректные значения пар ключ/значение для keychain элемента.
    
    // Создаем словарь возврата заполняемый атрибутами:
    NSMutableDictionary *returnDictionary = [NSMutableDictionary
                                             dictionaryWithDictionary:dictionaryToConvert];
    
    // Для получения данных пароля от элемента keychain,
    // сначала добавим ключ поиска и атрибут класса, необходимый для получения пароля:
    [returnDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    // Теперь вызов Keychain Services для получения пароля:
    CFDataRef passwordData = NULL;
    OSStatus keychainError = noErr; //
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary,
                                        (CFTypeRef *)&passwordData);
    if (keychainError == noErr)
    {
        // Удаляем kSecReturnData ключ; мы больше в нем не нуждаемся:
        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
        
        // Конвертируем пароль в NSString и добавляем в возвращаемый словарь:
        NSString *password = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)passwordData bytes]
                                                      length:[(__bridge NSData *)passwordData length]
                                                    encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:password forKey:(__bridge id)kSecValueData];
    }
    // Ничего не делать, если ничего не найдено.
    else if (keychainError == errSecItemNotFound) {
        NSAssert(NO, @"Nothing was found in the keychain.\n");
        if (passwordData) CFRelease(passwordData);
    }
    // Какая либо другая ошибка.
    else
    {
        NSAssert(NO, @"Serious error.\n");
        if (passwordData) CFRelease(passwordData);
    }
    
    return returnDictionary;
}
// Реализация метода writeToKeychain, который вызывает mySetObject метод,
// который в свою очередь вызывается через UI, когда есть новые данные для keychain. Этот
// метод изменяет существующий элемент keychain или - если элемент не
// существует - создает новый элемент keychain с новым значением атрибута плюс значениями
// по умолчанию для других атрибутов.
- (void)writeToKeychain
{
    CFDictionaryRef attributes = nil;
    NSMutableDictionary *updateItem = nil;
    
    // Если keychain элемент уже существует, модифицируем его:
    if (SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery,
                            (CFTypeRef *)&attributes) == noErr)
    {
        // Во-первых, получить атрибуты, возвращенные из keychain и добавить их в
        // словарь, который контролирует обновления:
        updateItem = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary *)attributes];
        
        // Во-вторых, получить значение класса из общего пароля словаря запроса и
        // добавить его в словарь updateItem:
        [updateItem setObject:[genericPasswordQuery objectForKey:(__bridge id)kSecClass]
                       forKey:(__bridge id)kSecClass];
        
        // Наконец, настроить словарь, содержащий новые значения для атрибутов:
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:keychainData];
        //Удаляем класс, который не keychain атрибут:
        [tempCheck removeObjectForKey:(__bridge id)kSecClass];
        
        // Вы можете обновить только один keychain элемент за раз.
        OSStatus errorcode = SecItemUpdate(
                                           (__bridge CFDictionaryRef)updateItem,
                                           (__bridge CFDictionaryRef)tempCheck);
        NSAssert(errorcode == noErr, @"Couldn't update the Keychain Item." );
    }
    else
    {
        // Если элемент не найден; добавить новый элемент.
        // Новое значение было добавлено в словарь keychainData в процедуре mySetObject,
        // И другие значения были добавлены в словарь keychainData ранее.
        // Указатель на вновь добавленные элементы не требуется, поэтому указываем NULL в качестве второго параметра:
        OSStatus errorcode = SecItemAdd(
                                        (__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:keychainData],
                                        NULL);
        
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:errorcode userInfo:nil];
        NSLog(@"%@", NSStringFromOSStatus(errorcode));
        NSLog(@"%@", error.localizedDescription);
        NSAssert(errorcode == noErr, @"Couldn't add the Keychain Item." );
        if (attributes) CFRelease(attributes);
    }
}

NSString *NSStringFromOSStatus(OSStatus errCode)
{
    if (errCode == noErr)
        return @"noErr";
    char message[5] = {0};
    *(UInt32*) message = CFSwapInt32HostToBig(errCode);
    return [NSString stringWithCString:message encoding:NSASCIIStringEncoding];
}



@end
