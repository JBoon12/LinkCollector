//
//  RealmManager.swift
//  LinkCollector
//
//  Created by Jinseok Hwang on 2020/03/26.
//  Copyright © 2020 Jinseok Hwang. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

final class RealmManager: NSObject {
    
    static let shared = RealmManager()
    let REALM_DEFAULT_SCHEME_VERSION:UInt64 = 1
    var sharedRealmConfiguration: Realm.Configuration? = nil
    var defaultRealmConfiguration: Realm.Configuration? = nil

    private override init(){

    }
    
    func setDefaultRealmForUser(username: String?) {
        if let username = username{
            var config = self.defaultRealmConfiguration
            
            let fileURL = self.realmFileURLWithBaseName(basename: username)
            if config == nil || config!.fileURL == fileURL{
                if let fileURL = fileURL {
                    config = self.defaultConfigurationWithFileURL(fileURL: fileURL)
                    self.defaultRealmConfiguration = config
                }
            }
            Realm.Configuration.defaultConfiguration = config!
            NSLog("\(String(describing: self.defaultRealmConfiguration))")
        }else{
            var config = Realm.Configuration()
            config.objectTypes = []
            Realm.Configuration.defaultConfiguration = config
            
            self.defaultRealmConfiguration = nil
            self.sharedRealmConfiguration = nil
            
        }
    }
    
    private func realmFileURLWithBaseName(basename: String) -> URL?{
        do {
            let documentDirectoryURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            
            let realmFileName = "\(basename)-LinkCollector.realm"
            
            return documentDirectoryURL.appendingPathComponent(realmFileName)
        }catch{
            return nil
        }
    }
    
    private func defaultConfigurationWithFileURL(fileURL:URL) -> Realm.Configuration {
        
        var config = self.configurationWithFileURL(fileURL: fileURL)
        config.schemaVersion = REALM_DEFAULT_SCHEME_VERSION
        config.objectTypes = [Link.self, MyLinkArray.self]
        
        config.migrationBlock = {(migration: Migration, oldSchemaVersion:UInt64) -> Void in
            var oldSchemaV = oldSchemaVersion
            while oldSchemaVersion < self.REALM_DEFAULT_SCHEME_VERSION {
                oldSchemaV += 1
                self.migrateSchema(newVersion: oldSchemaV, migration: migration)
            }
        }
        
        return config
    }
    
    private func configurationWithFileURL(fileURL: URL) -> Realm.Configuration{
        var config = Realm.Configuration()
        config.fileURL = fileURL
        return config
    }
    
    private func migrateSchema(newVersion:UInt64, migration:Migration){
        switch newVersion {
        case 2:
            migration.enumerateObjects(ofType: Link.className(),{(oldObject:MigrationObject?, newObject:MigrationObject?) -> Void in
            })
        
        default:
            print("DEFAULT")
        }
    }
}
