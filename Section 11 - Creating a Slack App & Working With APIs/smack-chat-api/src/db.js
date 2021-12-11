import mongoose from 'mongoose';
import config from './config';

export default callback => {
  let db;
  mongoose.Promise = global.Promise;
  mongoose.connect(
    config.mongoUrl,
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    },
    function (err, database) {
      if (err) {
        console.log(err);
        console.log('not connected to data base');
      } else {
        console.log('Successfully Connected to database');
        db = database;
        callback(db);
      }
    }
  );
};
