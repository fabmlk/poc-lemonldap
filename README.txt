notes LemonLDAP

- comme la conf se fait au niveau d'Apache, l'intégration d'une app web avec LemonLDAP nécéssite la présence d'un virtual host apache.
  Si l'appli est locale, rien de spé à faire, simplement ajouter:
     PerlHeaderParserHandler Lemonldap::NG::Handler

  Sinon, il faut configurer le virtual host comme un proxy vers la remote app, ex:
      $ cat misiv.conf
      <VirtualHost *:80>
        ServerName dev.misiv.example.com

        PerlHeaderParserHandler Lemonldap::NG::Handler

        SetOutputFilter INFLATE;SUBSTITUTE;DEFLATE
        ProxyPass / http://dev.misiv.intra.misiv.fr/
        ProxyPassReverse / http://dev.misiv.intra.misiv.fr/

        Substitute s|dev.misiv.intra.misiv.fr|dev.misiv.example.com|i
      </VirtualHost>


- créer view pour login misiv
  CREATE VIEW `login_codetms` AS

      SELECT 

        CONCAT_WS('__', `client_utilisateur`.`Login`,
 `client_info`.`CodeTMS`) AS `User`,

        `client_utilisateur`.`Password` AS `Password`,

        `client_utilisateur`.`Email` AS `Email`

      FROM
 `client_info`
 JOIN `client_utilisateur` ON `client_info`.`CodeTMS` = `client_utilisateur`.`CodeTMS` AND `client_utilisateur`.`Login` IS NOT NULL

- créer custom portal scheme pour ajouter codetms
   1/ créer misivform.tpl: idem standardform.tpl de bootstrap theme avec en plus un input:
       <div class="form-group input-group">
        <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i> </span>
        <input name="codetms" type="text" value="<TMPL_VAR NAME="CODETMS">" class="form-control" placeholder="Code TMS" required />
       </div>

   2/ copier login.tpl de bootstrap theme avec <TMPL_INCLUDE NAME="misivform.tpl"> au lieu de <TMPL_INCLUDE NAME="standardform.tpl">

   3/ créer js/codetms.js:
      $(document).ready(function(){
        $("input[name='codetms']").closest(".form-group").hide();

      $("#MiSIV")
        .find("form").on("submit", function () {
            var $userInput = $(this).find("input[name='user']");
            var codetms = $(this).find("input[name='codetms']").val();

            $userInput.val($userInput.val() + '__' + codetms);
        })
        .find("input[name='codetms']").closest(".form-group").show();
     });

   4/ ajouter dans customhead.tpl:
      <script src="/skins/tms/js/codetms.js"></script>

   5/ Ajouter une macro "user" avec en valeur: $_user =~ /__\d\d-\d\d\d\d\d\d$/ ? substr "$_user", 0, -11 : "$_user"
      puis utiliser $user comme variable à afficher pour "connecter en tant que" sur le portail (Portail -> Personnalisation -> Autres -> Attribut de l'utilisateur)

   6/ FIN: le reste est du linking et de la copie à partir du bootstrap theme comme évoqué à http://manager.example.com/fr-doc/pages/documentation/current/portalcustom.html


- variables sont stored dans user session
- exported variables sont collectées à partir du user backend ou perl CGI environement variables (http://www.cgi101.com/book/ch3/text.html, https://fr.wikipedia.org/wiki/Variables_d%27environnement_CGI)
- les macros permettent de créer des variables à partir d'autres variables, aka étendre ou override exported variables (strings ou boolean). Ex:
    $fullname -> $givename . '' . $username
    isAdmin -> $uid eq 'foo' or $uid eq 'bar'
- les macros sont évaluées par ordre alphabétique: macro suivante peut utiliser une macro précédente
- les variables peuvent être alors utilisées dans règles (pour gérer les autorisations d'accès), http headers (pour transmettre infos à la web app)
- les variables peuvent être définies "globalement" ou au niveau de chaque module (override les globaux)
- variables internes à LemonLDAP::NG:
  Modules:
    _auth		Authentication module
    _userDB		User module
    _passwordDB		Password module
    _issuerDB		Issuer module (can be multivalued)
    _authChoice		User choice done if authentication choice was used
    _authMulti		Full name of authentication module (with #label) used in Multi
    _userDBMulti	Full name of user module (with #label) used in Multi

  Connection:
    ipAddr		IP of the user (can be the X Forwarded For IP if trusted proxies are configured)
    _timezone		Timezone of the user, set with javascript from standard login form (will be empty if other authentication methods are used)
    _url		URL used before being redirected to the portal (empty if portal was used as entry point)

  Authentication:
    _session_id		Session identifier (carried in cookie)
    _user		User found from login process
    _password		Password found from login process (only if password store in session is configured)
    authenticationLevel	Authentication level

  Dates:
   _utime		Timestamp of session creation
   startTime		Date of session creation
   updateTime		Date of session last modification
   _lastAuthnUTime	Timestamp of last authentication time

  Spécifiques SAML, LDAP, OpenID, OpenID Connect
   => voir doc

  Autres:
    appsListOrder	Order of categories in the menu
   _session_kind	Type of session (SSO, Persistent, …)
   _notification_id	Date of validation of the notification id

  https://lemonldap-ng.org/documentation/latest/variables

- rules permettent de contrôller l'accès aux (URL) d'une app (virtual hosts) via:
    accept: all authenticated users can pass
    deny: nobody is welcomed
    skip: all is open!
    unprotect: all is open, but authenticated users are seen as authenticated
    logout_sso, logout_app, logout_app_sso: catch logout request
    Perl expression: perl code snippet that returns 0 or 1 (possibilité d'utiliser exported variables, macros ou groups), ex: $groups =~ /\badministrators\b/
- les groups sont comme une macro spéciale de nom "$groups" qui contient la liste des valeurs ayant retourné une valeur non nulle après évaluation
- crons: voir /etc/cron.d/liblemonldap-ng*