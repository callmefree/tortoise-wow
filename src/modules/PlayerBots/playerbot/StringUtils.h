#pragma once

#include <string>
#include <algorithm>

namespace StringUtils {

// Case-insensitive string comparison
inline bool icasecmp(const std::string& a, const std::string& b) {
    if (a.size() != b.size()) return false;
    return std::equal(a.begin(), a.end(), b.begin(),
        [](char c1, char c2) { return std::tolower(c1) == std::tolower(c2); });
}

// Case-insensitive starts_with
inline bool istarts_with(const std::string& str, const std::string& prefix) {
    if (prefix.size() > str.size()) return false;
    return std::equal(prefix.begin(), prefix.end(), str.begin(),
        [](char c1, char c2) { return std::tolower(c1) == std::tolower(c2); });
}

// Case-insensitive contains
inline bool icontains(const std::string& str, const std::string& substr) {
    if (substr.empty()) return true;
    if (substr.size() > str.size()) return false;
    
    for (size_t i = 0; i <= str.size() - substr.size(); ++i) {
        bool match = true;
        for (size_t j = 0; j < substr.size(); ++j) {
            if (std::tolower(str[i + j]) != std::tolower(substr[j])) {
                match = false;
                break;
            }
        }
        if (match) return true;
    }
    return false;
}

// Case-insensitive equals (same as icasecmp)
inline bool iequals(const std::string& a, const std::string& b) {
    return icasecmp(a, b);
}

// Trim whitespace from both ends of a string
inline void trim(std::string& str) {
    auto is_space = [](unsigned char c) { return std::isspace(c); };
    
    // Trim from start
    str.erase(str.begin(), std::find_if(str.begin(), str.end(), std::not_fn(is_space)));
    
    // Trim from end
    str.erase(std::find_if(str.rbegin(), str.rend(), std::not_fn(is_space)).base(), str.end());
}

// Trim whitespace from right end of a string
inline void trim_right(std::string& str) {
    auto is_space = [](unsigned char c) { return std::isspace(c); };
    str.erase(std::find_if(str.rbegin(), str.rend(), std::not_fn(is_space)).base(), str.end());
}

} // namespace StringUtils