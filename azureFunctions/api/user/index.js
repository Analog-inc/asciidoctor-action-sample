module.exports = async function (context, req) {
    const response = await fetch("/.auth/me");
    const payload = await response.json();

    if (payload.userDetails.indexOf('@') != -1 ) {
      context.res = {
          serve: req.path
      };
    else {
        context.res = {
            status: 401
        };
    }
};
