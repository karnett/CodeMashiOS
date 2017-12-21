//
//  FiltersViewModel.swift
//  codemash
//
//  Created by Kim Arnett on 12/14/17.
//  Copyright © 2017 karnett. All rights reserved.
//

import Foundation
import ObjectMapper

class FiltersViewModel {
    
    private var selectedFilters: [Int] = []
    
    init() {
        selectedFilters = prefs.array(forKey: filterKey) as? [Int] ?? []
    }
    
    func getFiltersCount() -> Int {
        return filters.count
    }
    
    func isFilterSelected(index: Int) -> Bool {
        return selectedFilters.contains(index)
    }
    
    func getFilterAtIndex(row: Int) -> String? {
        return filters[row] 
    }
    
    func updateFilterAtIndex(filterIndex: Int, selected: Bool) {
        if selected {
            selectedFilters.append(filterIndex)
        } else if let selectedIndex = selectedFilters.index(of: filterIndex) {
            selectedFilters.remove(at: selectedIndex)
        }
    }
    
    func saveSelectedFilters() {
        prefs.set(Array(Set(selectedFilters)), forKey: filterKey)
    }
}
