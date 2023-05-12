import pg8000
import getpass


###############################
# EDIT BELOW HERE (SEE TODOs) #
###############################

def search_by_artist(cursor, search_string):
    query = """SELECT ar.name, al.title, al.year, al.id 
               FROM artist AS ar, album AS al
               WHERE lower(ar.name) LIKE lower(%s)
               AND ar.id = al.artist_id
               ORDER BY ar.name, al.year, al.title"""

    search_string = '%' + search_string + '%'
    try:
        cursor.execute(query, (search_string, ))

        resultset = cursor.fetchall()
        return resultset

    except pg8000.Error as e:
        print("Database error\n")
        return None

def search_by_album(cursor, search_string):
    query = """SELECT ar.name, al.title, al.year, al.id
                FROM artist AS ar, album AS al
                WHERE lower(al.title) LIKE lower(%s)
                AND ar.id = al.artist_id
                ORDER BY ar.name, al.year, al.title"""

    search_string = '%' + search_string + '%'
    try:
        cursor.execute(query, (search_string, ))

        resultset = cursor.fetchall()
        return resultset

    except pg8000.Error as e:
        print("Database error\n")
        return None
    return [['Search by album', search_string, '?', '(al.title)']]

def insert_artist(cursor, artist_name):
    # TODO: implement this
    query = "INSERT INTO artist (name) VALUES (%s)"

    try:
        cursor.execute(query, (artist_name, ))
        db.commit()            
        return True

    except pg8000.Error as e:
        messagebox.showerror("Database error\n", e)
        db.rollback()
        return None
    print('Save new artist: ' + artist_name + ' (name)')

def insert_album(cursor, album_name, year, artist_name):
    query = "INSERT INTO album (artist_id, title, year) VALUES (%s, %s, %s)"
    subquery = """SELECT ar.id
                  FROM artist AS ar
                  WHERE lower(ar.name) LIKE lower(%s)"""
    try:        
        # TODO: implement this: replace the print statement below (leave the try and except alone!)
        print('Save new album: ' + artist_name + ' - ' + album_name + ' (' + year + ')' + ' (Not yet implemented)')
    except pg8000.Error as e:
        print("Artist does not exist or duplicate album.")
        print('Details: ' + artist_name + ' - ' + album_name + ' (' + year + ')')
        print(e)

def update_album(cursor, album_id, album_name, year):
    query = """UPDATE album
                SET title=%s, year=%s
                WHERE id=%s"""
    try:        
        # TODO: implement this: replace the print statement below (leave the try and except alone!)
        print('Update album: ' + str(album_id) + ': ' + album_name + ' (' + year + ')' + ' (Not yet implemented)')
    except pg8000.Error as e:
        print("Album does not exist (invalid album id), or not properly implemented.")
        print('Details: ' + album_id + ' - ' + album_name + ' (' + year + ')')
        print(e)
        
def delete_album(cursor, album_id):
    query = """DELETE FROM album WHERE id = %s """
    try:        
        # TODO: implement this: replace the print statement below (leave the try and except alone!)
        print('Delete album: ' + str(album_id) + ' (Not yet implemented)')
    except pg8000.Error as e:
        print("Album does not exist (invalid album id), or not properly implemented.")
        print('Details: ' + album_id)
        print(e)

def get_artists(cursor):
    query = """ SELECT name FROM artist
                    ORDER BY name """
    try:        
        # TODO: replace this with something that queries the database
        return ['Chris Thile', 'Hiromi', 'Jethro Tull']
    except pg8000.Error as e:
        print(e)
        return None


#######################################
# END OF SECTION FOR STUDENTS TO EDIT #
#######################################






##########################
# DO NOT EDIT BELOW HERE #
##########################

def printResultSet(resultSet):
    print(" ")
    if (len(resultSet)==0):
        print("NO RESULTS FOUND")
    else:
        for artist, title, year, album_id in resultSet:
            s = artist + ' - ' + title + ' (' + str(year) + ')' + ' id: ' + str(album_id)
            print(s)

def printArtists(resultSet):
    if (len(resultSet)==0):
        print("NO RESULTS FOUND")
    else:
        for artist in resultSet:
            print(artist)

def search(cursor):
    while(True):
        choice = input ("Search by Artist (R) or Album (L)?: ")
        if (choice == 'R' or choice == 'r'):
            search_str = input ("Enter Artist name (Wildcard allowed: % and _): ")
            printResultSet(search_by_artist(cursor, search_str))
            break
        elif (choice == 'L' or choice == 'l'):
            search_str = input ("Enter Album name (Wildcard allowed: % and _): ")
            printResultSet(search_by_album(cursor, search_str))
            break
        else: 
            print("Invalid choice. Try again.")
        print(" ")

def insert(cursor):
    while(True):
        choice = input ("Insert Artist (R) or Album (L)?: ")
        if (choice == 'R' or choice == 'r'):
            name = input ("Enter Artist name: ")
            insert_artist(cursor, name)
            break
        elif (choice == 'L' or choice == 'l'):
            al_name = input ("Enter Album name: ")
            year = input ("Enter Album year: ")
            ar_name = input ("Enter Artist name: ")
            insert_album(cursor, al_name, year, ar_name)
            break
        else: 
            print("Invalid choice. Try again.")
        print(" ")

def update(cursor):
    al_id = input ("Enter Album id: ")
    al_name = input ("Enter NEW Album name: ")
    al_year = input ("Enter NEW Album year: ")
    update_album(cursor, al_id, al_name, al_year)

def delete(cursor):
    al_id = input ("Enter Album id: ")
    delete_album(cursor, al_id)

def getArtists(cursor):
    printArtists(get_artists(cursor))



print(" ")
while (True):
    username = input ("Username: ")
    password = getpass.getpass('Password: ')

    try:        
        credentials = {'user'     : username,
                        'password' : password,
                        'database' : 'csci403',
                        'port'     : 5433,
                        'host'     : 'codd.mines.edu' }
        db = pg8000.connect(**credentials)
        # do not change the autocommit line below or set autocommit to true in your solution
        # this lab requires you add appropriate db.commit() calls
        db.autocommit = False
        cursor = db.cursor()
        print(" ")
        break
    except pg8000.Error as e:
        print("Authentication failed for user \"" + username + "\"\n")

while (True):
    choice = input ("Menu:\nSearch (S)\nInsert (I)\nUpdate (U)\nDelete (D)\nGet Artists (G)\nQuit (Q)\nEnter your choice: ")
    print(" ")
    if (choice == 'S' or choice == 's'):
        search(cursor)
    elif (choice == 'I' or choice == 'i'):
        insert(cursor)
    elif (choice == 'U' or choice == 'u'):
        update(cursor)
    elif (choice == 'D' or choice == 'd'):
        delete(cursor)
    elif (choice == 'G' or choice == 'g'):
        getArtists(cursor)
    elif (choice == 'Q' or choice == 'q'):
        print(" ")
        break
    else:
        print("Invalid choice. Try again.")
    print(" ")



