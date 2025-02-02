import { UnavailabilityError } from '@unimodules/core';
import ExpoGoogleSignIn from './ExpoGoogleSignIn';
import GoogleAuthentication from './GoogleAuthentication';
import GoogleIdentity from './GoogleIdentity';
class GoogleUser extends GoogleIdentity {
    auth;
    scopes;
    hostedDomain;
    serverAuthCode;
    constructor(options) {
        super(options);
        const { auth, scopes, hostedDomain, serverAuthCode } = options;
        this.auth = auth;
        this.scopes = scopes;
        this.hostedDomain = hostedDomain;
        this.serverAuthCode = serverAuthCode;
    }
    clearCache = async () => {
        if (!ExpoGoogleSignIn.clearCacheAsync) {
            return;
        }
        if (!this.auth || !this.auth.accessToken) {
            throw new Error('GoogleSignIn: GoogleUser.clearCache(): Invalid accessToken');
        }
        return await ExpoGoogleSignIn.clearCacheAsync({ token: this.auth.accessToken });
    };
    getHeaders = () => {
        if (!this.auth || !this.auth.accessToken || !this.auth.accessToken.length) {
            throw new Error('GoogleSignIn: GoogleUser.getHeaders(): Invalid accessToken');
        }
        return {
            Authorization: `Bearer ${this.auth.accessToken}`,
            Accept: 'application/json',
            'Content-Type': 'application/json',
        };
    };
    refreshAuth = async () => {
        if (!ExpoGoogleSignIn.getTokensAsync) {
            throw new UnavailabilityError('GoogleSignIn', 'getTokensAsync');
        }
        const response = await ExpoGoogleSignIn.getTokensAsync(false);
        if (response.idToken == null && this.auth) {
            response.idToken = this.auth.idToken;
        }
        if (!this.auth) {
            this.auth = new GoogleAuthentication(response);
        }
        else {
            this.auth.idToken = response.idToken;
            this.auth.accessToken = response.accessToken;
        }
        return this.auth;
    };
    equals(other) {
        if (!super.equals(other) || !(other instanceof GoogleUser)) {
            return false;
        }
        if (this.auth != null) {
            return (this.auth.equals(other.auth) &&
                this.scopes === other.scopes &&
                this.hostedDomain === other.hostedDomain &&
                this.serverAuthCode === other.serverAuthCode);
        }
        else {
            return other.auth == null;
        }
    }
    toJSON() {
        let auth = this.auth;
        if (this.auth && this.auth.toJSON) {
            auth = this.auth.toJSON();
        }
        return {
            ...super.toJSON(),
            auth,
            scopes: this.scopes,
            hostedDomain: this.hostedDomain,
            serverAuthCode: this.serverAuthCode,
        };
    }
}
export default GoogleUser;
//# sourceMappingURL=GoogleUser.js.map