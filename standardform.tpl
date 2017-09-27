<div class="form">
    <div class="logo"><img src="http://test.misiv.intra.misiv.fr/css/images/logo_misiv.png"></div>
    <div class="misiv-input-group">
        <span class="misiv-input-label">Code TMS</span>
        <input name="codetms" type="text" value="<TMPL_VAR NAME="CODETMS">" class="misiv-input-element" required />
    </div>

    <div class="misiv-input-group">
        <span class="misiv-input-label">Identifiant</span>
        <input name="user" type="text" value="<TMPL_VAR NAME="LOGIN">" class="misiv-input-element" placeholder="<lang en="Login" fr="Identifiant"/>" required />
    </div>

    <div class="misiv-input-group">
        <span class="misiv-input-label">Mot de passe</span>
        <input name="password" type="password" class="misiv-input-element" placeholder="<lang en="Password" fr="Mot de passe"/>" required />
    </div>

    <TMPL_IF NAME=CAPTCHA_IMG>
        <div class="form-group">
            <img src="<TMPL_VAR NAME=CAPTCHA_IMG>" class="img-thumbnail" />
        </div>
        <div class="form-group input-group">
            <span class="input-group-addon"><i class="glyphicon glyphicon-eye-open"></i> </span>
            <input type="text" name="captcha_user_code" size="<TMPL_VAR NAME=CAPTCHA_SIZE>" class="form-control" placeholder="Captcha" required />
        </div>
        <input type="hidden" name="captcha_code" value="<TMPL_VAR NAME=CAPTCHA_CODE>" />
    </TMPL_IF>

        <button type="submit" class="btn btn-success" >
            <lang en="Connect" fr="Se connecter" />
        </button>
</div>