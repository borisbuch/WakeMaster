//
//  MyEnumProtocol.swift
//  WakeMaster
//
//  Created by Boris on 27.03.26.
//

import SwiftUI

// Damit ich ich bei SectionHeaderView() verschiedene EnumsTypen mit den selben eigenschaften übergeben kann
protocol MyEnumProtocol: RawRepresentable where RawValue == String{
    var color: Color { get }
    var symbol: String { get}
}
