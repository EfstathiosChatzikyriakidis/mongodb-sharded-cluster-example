function randomString (len) {
    var charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    var randomString = '';

    for (var i = 0; i < len; i++) {
        var randomPoz = Math.floor(Math.random() * charSet.length);

        randomString += charSet.substring(randomPoz,randomPoz+1);
    }

    return randomString;
}

use school;

sh.enableSharding("school")

sh.shardCollection("school.students", { email: 1 } )

data = [];

for (i = 0; i < 1000000; i++) {
  data.push({email: randomString(40)});
}

db.students.insertMany(data, {ordered: false, writeConcern: {w: 0, j: false}});