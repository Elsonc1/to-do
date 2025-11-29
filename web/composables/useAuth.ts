export interface User {
  id: string;
  email: string;
  nome: string;
}

export interface AuthResponse {
  user: User;
  token: string;
}

export interface RegisterDTO {
  email: string;
  password: string;
  nome: string;
}

export interface LoginDTO {
  email: string;
  password: string;
}

export const useAuth = () => {
  const config = useRuntimeConfig();
  const apiBase = config.public.apiBase;

  const token = useCookie<string | null>('auth_token', { default: () => null });
  const user = useCookie<User | null>('auth_user', { default: () => null });

  const register = async (data: RegisterDTO): Promise<AuthResponse> => {
    try {
      const response = await $fetch<AuthResponse>(`${apiBase}/auth/register`, {
        method: 'POST',
        body: data
      });

      token.value = response.token;
      user.value = response.user;

      return response;
    } catch (error) {
      console.error('Erro ao registrar:', error);
      throw error;
    }
  };

  const login = async (data: LoginDTO): Promise<AuthResponse> => {
    try {
      const response = await $fetch<AuthResponse>(`${apiBase}/auth/login`, {
        method: 'POST',
        body: data
      });

      token.value = response.token;
      user.value = response.user;

      return response;
    } catch (error) {
      console.error('Erro ao fazer login:', error);
      throw error;
    }
  };

  const logout = () => {
    token.value = null;
    user.value = null;
    navigateTo('/login');
  };

  const isAuthenticated = computed(() => !!token.value && !!user.value);

  const getAuthHeaders = () => {
    if (!token.value) return {};
    return {
      Authorization: `Bearer ${token.value}`
    };
  };

  return {
    register,
    login,
    logout,
    token,
    user,
    isAuthenticated,
    getAuthHeaders
  };
};

