*! version 0.2, 02jan2015, Max Loeffler <loeffler@zew.de>
/**
 * WORDWRAP - WRAPS A STRING TO A SPECIFIC NUMBER OF CHARACTERS
 *
 * Reads long strings and wraps them to a specific line length. It returns
 * a properly wrapped multi-line version of the same string. No hyphenation.
 *
 * This ado-file is very similar to the code by Scott Merryman and Raymond P.
 * Guiteras posted on the Stata list. All credit goes to them for pointing out
 * this simple way of breaking long lines even years ago:
 *  - http://www.stata.com/statalist/archive/2007-03/msg00778.html
 *  - http://www.stata.com/statalist/archive/2008-01/msg00579.html
 *
 * 2014-11-25   Initial version (v0.1)
 * 2015-01-02   Bugfix (return text if length < maxlength)
 *
 *
 * Copyright (C) 2014-2015 Max Löffler <loeffler@zew.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */


/**
 * @param `0'      Pass thru for string to wrap
 * @param `length' Maximum number of chars per line
 */
program define wordwrap, rclass
    version 13
    syntax anything(id=text name=text) [, Length(integer 80)]

    // Init
    local len = length(`text')
    local tot = ceil(`len' / `length')

    // Check if word wrap necessary
    if (`len' > `length') {
        // Loop over pieces
        forval i = 1/`tot' {
            local sub : piece `i' `length' of `text', nobreak
            local out = cond(`i' == 1, `""`sub'""', `"`out' "`sub'""')
        }
    }
    // We are fine.
    else local out `""`text'""'

    // Return wrapped string
    return local text `out'
end

***
