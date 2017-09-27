<div class="misiv-form">
    <div class="misiv-logo"><img src="http://test.misiv.intra.misiv.fr/css/images/logo_misiv.png"></div>

    <div class="misiv-echo">
        <TMPL_IF NAME="AUTH_ERROR">
            <div class="message message-<TMPL_VAR NAME="AUTH_ERROR_TYPE"> alert"><TMPL_VAR NAME="AUTH_ERROR"></div>
        </TMPL_IF>
    </div>

    <div class="misiv-form-body">
        <div class="misiv-input-group">
            <span class="misiv-input-label">Code TMS</span>
            <input name="codetms" type="text" value="<TMPL_VAR NAME=" CODETMS">" class="misiv-input-element" required />
        </div>

        <div class="misiv-input-group">
            <span class="misiv-input-label">Identifiant</span>
            <input name="user" type="text" value="<TMPL_VAR NAME=" LOGIN">" class="misiv-input-element" required />
        </div>

        <div class="misiv-input-group">
            <span class="misiv-input-label">Mot de passe</span>
            <input name="password" type="password" class="misiv-input-element" required />
        </div>

    </div>

        <button type="submit" class="misiv-button">
            <lang en="Connect" fr="Se connecter"/>
        </button>

</div>