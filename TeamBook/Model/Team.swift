//
//  File.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/19.
//

import Foundation
import RealmSwift
class Team: Object {
    @objc dynamic var whichTeamRealm: String = ""
    @objc dynamic var userNameEmail: String = ""
}
struct TeamsSelection{
    let whichTeam: String
}
