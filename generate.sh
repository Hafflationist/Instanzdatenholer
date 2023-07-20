if [ -z "${1}" ]
then
    echo "Geben sie eine der folgenden DBs als Parameter an:"
    mycli --csv -e "\\l" -u guest -h relational.fit.cvut.cz -p relational
else
    rm -f ./*.csv
    rm -f ./*.sql
    rm -f ./daten/*.csv
    rm -f ./daten/*.sql
    tables=$(mycli --csv -e "\\u ${1}; \\dt" -u guest -h relational.fit.cvut.cz -p relational |
        tail -n +2 |
        sed 's|"||g' |
        tr '\n' ' ')
    for item in $tables
    do
        echo $item
        mkdir -p daten
        mycli --csv -e "select * from ${item};" -u guest -h relational.fit.cvut.cz -p relational $1 >> daten/$item.csv
        mycli --csv -e "show create table ${item};" -u guest -h relational.fit.cvut.cz -p relational $1 |
            tail -n +2 |
            sed 's|.*","||' |
            sed 's|"||' >> daten/$item.sql
    done
fi
