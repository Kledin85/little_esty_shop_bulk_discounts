app.listen(process.env.PORT || 3000, function(){
  console.log("Express server listening on port %d in %s mode", this.address().port, app.settings.env);
});

web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-devlopment}
